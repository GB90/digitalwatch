/*
2014 Jasper ter Weeme

A simple digital watch displays the time of day. Setting of the time is
achieved by two buttons. Button #1 will switch from displaying time mode
to increment hours mode. In this mode the hours flash and pressing
button #2 will increment the hours each time it is pressed. Further
pressing of button #1 switches to increment minutes
mode. Button #2 functions in the same way as before. If button #1 is
pressed again the watch returns to display time mode. Time is not kept
whilst being set.
*/

#include <system.h>
#include <stdint.h>
#include <sys/alt_irq.h>
#include "uart.h"
#include "misc.h"
#include "rtc.h"

class Leds
{
    volatile uint8_t * const handle;
public:
    Leds() : handle(0) { }
    Leds(volatile uint8_t * const base) : handle(base) { }
    void write(const uint8_t data) { *handle = data; }
};

class IWatch
{
public:
    virtual void timerTick() = 0;
    virtual void nextMode() = 0;
    virtual void increment() = 0;
    virtual Leds *getLeds() = 0;
    virtual Uart *getUart() = 0;
    virtual RTC *getRTC() = 0;
    virtual TimeDisplay *getTimeDisplay() = 0;
};

class AbstractMode
{
protected:
    IWatch *context;
public:
    AbstractMode(IWatch *context) : context(context) { }
    virtual void init() { }
    virtual void increase() {}
    virtual void timerTick() {}
};

class IncrementHoursMode : public AbstractMode
{
public:
    IncrementHoursMode(IWatch *);
    void init();
    void increase();
    static const uint8_t ID = 2;
};

class IncrementMinutesMode : public AbstractMode
{
public:
    IncrementMinutesMode(IWatch *);
    void init();
    void increase();
    static const uint8_t ID = 3;
};

class DisplayTimeMode : public AbstractMode
{
public:
    DisplayTimeMode(IWatch *);
    void init();
    void timerTick();
    static const uint8_t ID = 1;
};

class Watch : public IWatch
{
    Uart uart;
    JtagUart jtagUart;
    Leds leds;
    Buttons buttons;
    TimeDisplay segDisplay;
    Timer timer;
    RTC *rtc;
    Terminal *debugger;
    uint8_t mode;
    AbstractMode *mode2;
public:
    Watch();
    TimeDisplay *getTimeDisplay() { return &segDisplay; }
    Leds *getLeds() { return &leds; }
    RTC *getRTC() { return rtc; }
    Uart *getUart() { return &uart; }
    Terminal *getDebugger() { return debugger; }
    void nextMode();
    void increment() { mode2->increase(); }
    void timerTick() { mode2->timerTick(); }
};

class TimerTick : public Observer
{
    IWatch *watch;
public:
    TimerTick(IWatch *watch) : watch(watch) { }
    void update() { watch->timerTick(); }
};

class ButtonS4Action : public Observer
{
    IWatch *watch;
public:
    ButtonS4Action(IWatch *watch) : watch(watch) { }
    void update() { watch->nextMode(); }
};

class ButtonS5Action : public Observer
{
    IWatch *watch;
public:
    ButtonS5Action(IWatch *watch) : watch(watch) { }
    void update() { watch->increment(); }
};

Watch::Watch() :
#ifdef LEDS_BASE
    leds((uint8_t *)LEDS_BASE),
#endif
    buttons((void *)BUTTONS_BASE, BUTTONS_IRQ_INTERRUPT_CONTROLLER_ID, BUTTONS_IRQ),
#ifdef SEGDISPLAY_BASE
    segDisplay((uint32_t *)SEGDISPLAY_BASE),
#endif
    timer((void *)TIMER_0_BASE, TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_0_IRQ),
    uart((uint32_t *)UART_0_BASE),
    jtagUart((uint32_t *)JTAG_UART_0_BASE)
{
    debugger = JtagUart::getInstance();
    mode = DisplayTimeMode::ID;
    mode2 = new DisplayTimeMode(this);
    mode2->init();
    debugger->puts("Initializing Digital Watch...\r\n");
    volatile uint32_t * const clk = (uint32_t *)DS1302_CLK_BASE;
    volatile uint32_t * const io = (uint32_t *)DS1302_IO_BASE;
    volatile uint32_t * const rst = (uint32_t *)DS1302_RESET_BASE;
    RTCFactory rtcFactory(clk, io, rst);
    rtc = rtcFactory.createRTC();
    buttons.setObserver(new ButtonS4Action(this), 4);
    buttons.setObserver(new ButtonS5Action(this), 5);
    timer.setObserver(new TimerTick(this));
}

DisplayTimeMode::DisplayTimeMode(IWatch *context) : AbstractMode(context)
{
}

void DisplayTimeMode::init()
{
    context->getLeds()->write(~1);
    context->getTimeDisplay()->setBlinkMask(0);
}

IncrementMinutesMode::IncrementMinutesMode(IWatch *context) : AbstractMode(context)
{
}

void IncrementMinutesMode::init()
{
    context->getLeds()->write(~4);
    context->getTimeDisplay()->setBlinkMask(3);
}

IncrementHoursMode::IncrementHoursMode(IWatch *context) : AbstractMode(context)
{
}

void IncrementHoursMode::init()
{
    context->getLeds()->write(~2);
    context->getTimeDisplay()->setBlinkMask(0x0c);
}

void IncrementHoursMode::increase()
{
    RTC *rtc = context->getRTC();
    rtc->incrementHours();
    context->getTimeDisplay()->setTime(rtc->getTimeStamp());
}

void IncrementMinutesMode::increase()
{
    RTC *rtc = context->getRTC();
    rtc->incrementMinutes();
    context->getTimeDisplay()->setTime(rtc->getTimeStamp());
}

void DisplayTimeMode::timerTick()
{
    RTC *rtc = context->getRTC();
    rtc->update();
    TimeStamp *ts = rtc->getTimeStamp();
    context->getUart()->puts(ts->toString());
    context->getTimeDisplay()->setTime(ts);
}

void Watch::nextMode()
{
    delete mode2;

    if (++mode > IncrementMinutesMode::ID)
        mode = DisplayTimeMode::ID;

    switch (mode)
    {
        case DisplayTimeMode::ID:
            mode2 = new DisplayTimeMode(this);
            mode2->init();
            break;
        case IncrementHoursMode::ID:
            mode2 = new IncrementHoursMode(this);
            mode2->init();
            break;
        case IncrementMinutesMode::ID:
            mode2 = new IncrementMinutesMode(this);
            mode2->init();
            break;
        default:
            leds.write(0xff);
            break;
    }
}

Timer::Timer(volatile void * const base, const unsigned ctl, const unsigned irq)
  :
    base(base),
    base32((uint32_t *)base)
{
    instance = this;
    alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_0_IRQ, isr, 0, 0);
}

Timer *Timer::instance;

void JtagUart::putc(const char c)
{
    while (*ctl & 0xffff0000 == 0) { }
    base[0] = c;
}

Uart *Uart::instance;
JtagUart *JtagUart::instance;

void Uart::putc(const char c)
{
    while ((base[2] & (1<<6)) == 0) { }
    base[1] = c;
}

int main()
{
    Watch watch;

    while (true)
    {
        // wachten op interrupts
    }

    return 0;
}


