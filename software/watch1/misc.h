/*
2014 Jasper ter Weeme
*/

#ifndef _OBSERVER_H_
#define _OBSERVER_H_
#include <stdint.h>

struct ds1302_struct
{
  uint8_t Seconds:4;
  uint8_t Seconds10:3;
  uint8_t CH:1;
  uint8_t Minutes:4;
  uint8_t Minutes10:3;
  uint8_t reserved1:1;
  union
  {
    struct
    {
      uint8_t Hour:4;
      uint8_t Hour10:2;
      uint8_t reserved2:1;
      uint8_t hour_12_24:1;
    } h24;
    struct
    {
      uint8_t Hour:4;
      uint8_t Hour10:1;
      uint8_t AM_PM:1;
      uint8_t reserved2:1;
      uint8_t hour_12_24:1;
    } h12;
  };
  uint8_t Date:4;
  uint8_t Date10:2;
  uint8_t reserved3:2;
  uint8_t Month:4;
  uint8_t Month10:1;
  uint8_t reserved4:3;
  uint8_t Day:3;
  uint8_t reserved5:5;
  uint8_t Year:4;
  uint8_t Year10:4;
  uint8_t reserved6:7;
  uint8_t WP:1;
};

class TimeStamp
{
private:
    ds1302_struct ds;
public:
    TimeStamp(ds1302_struct ds) { this->ds = ds; }
    ds1302_struct *getDS() { return &ds; }
    const char *toString();
    uint8_t getHour10() { return ds.h24.Hour10; }
    uint8_t getHour() { return ds.h24.Hour; }
    uint8_t getMinutes10() { return ds.Minutes10; }
    uint8_t getMinutes() { return ds.Minutes; }
};

class Observer
{
public:
    virtual void update() = 0;
};

/*
Timer is Singleton en Observable
*/
class Timer
{

private:
    Timer();
    Observer *rh;
    void update();
    static void isr(void *context);
    volatile void *base;
    volatile uint32_t *base32;
public:
    static Timer *getInstance();
    void setObserver(Observer *obs) { rh = obs; }
    void init(volatile void *base);
};

class Buttons
{
public:
    static Buttons *getInstance();
    void setObserver(Observer *, int);
    void init(volatile void *base);
private:
    volatile void *base;
    volatile uint32_t *base32;
    void update();
    static void isr(void *context) { getInstance()->update(); }
    Observer *s4;
    Observer *s5;
    Observer *s6;
    static const uint8_t BUTTON_S4 = 3;
    static const uint8_t BUTTON_S5 = 5;
};

class SegDisplay
{
public:
    SegDisplay(volatile uint32_t * const);
    void write(uint32_t);
    void setBlinkMask(uint8_t);
private:
    volatile uint32_t *handle;
    void init(volatile uint32_t * const);
    volatile uint8_t *blinkMask;
};

class TimeDisplay : public SegDisplay
{
public:
    TimeDisplay(volatile uint32_t * const);
    void setMinutes(uint8_t);
    void setTime(uint8_t, uint8_t);
    void setTime(TimeStamp *);
private:
    static uint8_t lookup[];
};


#endif
