#define SYSTEM_BUS_WIDTH 32

#include "ds1302.h"
#include <stdio.h>
#include <unistd.h>
#include <system.h>
#include <io.h>

DS1302::DS1302()
{
    init();
}

FallBackRTC::FallBackRTC()
{
}

TimeStamp::TimeStamp(ds1302_struct ds)
{
    this->ds = ds;
}

int DS1302::bcd2bin(int hi, int lo)
{
    return hi * 10 + lo;
}

TimeStamp *DS1302::getTimeStamp()
{
    return new TimeStamp(rtc);
}

TimeStamp *FallBackRTC::getTimeStamp()
{
    return new TimeStamp(rtc);
}

uint8_t TimeStamp::getHour10()
{
    return ds.h24.Hour10;
}

uint8_t TimeStamp::getHour()
{
    return ds.h24.Hour;
}

uint8_t TimeStamp::getMinutes10()
{
    return ds.Minutes10;
}

uint8_t TimeStamp::getMinutes()
{
    return ds.Minutes;
}

void DS1302::update()
{
    start();
    toggleWrite(DS1302::CLOCK_BURST_READ, true);
    uint8_t *p = (uint8_t *)&rtc;

    for (int i = 0; i < 8; i++)
        *p++ = toggleRead();

    stop();

}

void DS1302::write(int address, uint8_t data)
{
    address &= ~(1<<0);
    start();
    toggleWrite(address, false);
    toggleWrite(data, false);
    stop();
}

const char *TimeStamp::toString()
{
    static char buffer[80];

    sprintf(buffer, "Time = %c%c:%c%c:%c%c\r\n", ds.h24.Hour10 + 48,
        ds.h24.Hour + 48, ds.Minutes10 + 48, ds.Minutes + 48,
        ds.Seconds10 + 48, ds.Seconds + 48);

    return buffer;
}

void DS1302::stop()
{
    *reset_handle = 0;
    ::usleep(4);
}

DS1302 *DS1302::getInstance()
{
    static DS1302 instance;
    return &instance;
}

uint8_t DS1302::toggleRead()
{
    uint8_t data = 0;

    for (int i = 0; i <= 7; i++)
    {
        *clk_handle = 1;
        ::usleep(1);
        *clk_handle = 0;
        ::usleep(1);
        *io_handle ? data |= (1<<i) : data &= ~(1<<i);
    }

    return data;
}

void DS1302::toggleWrite(uint8_t data, uint8_t release)
{
    for (int i = 0; i <= 7; i++)
    {
        *io_handle = (data >> i) & 1;
        ::usleep(1);
        *clk_handle = 1;
        ::usleep(1);

        if (release && i == 7)
        {
            IOWR(DS1302_IO_BASE, 1, 0);
        }
        else
        {
            *clk_handle = 0;
            ::usleep(1);
        }
    }
}

RTC *RTCFactory::createRTC()
{
    //return FallBackRTC::getInstance();
    return DS1302::getInstance();
}

void DS1302::init()
{
    io_handle = (volatile bool *)DS1302_IO_BASE;
    clk_handle = (volatile bool *)DS1302_CLK_BASE;
    reset_handle = (volatile bool *)DS1302_RESET_BASE;

    write(DS1302::ENABLE, 0);
    write(DS1302::TRICKLE, 0);
}

void DS1302::start()
{
    *reset_handle = 0;
    *clk_handle = 0;
    IOWR(DS1302_IO_BASE, 1, 1);
    *reset_handle = 1;
    ::usleep(4);
}

int DS1302::digitalLees(int n)
{
    return 0;
}

FallBackRTC *FallBackRTC::getInstance()
{
    static FallBackRTC instance;
    return &instance;
}

void FallBackRTC::update()
{
}

