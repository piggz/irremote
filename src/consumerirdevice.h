#ifndef CONSUMERIRDEVICE_H
#define CONSUMERIRDEVICE_H

#include <QObject>
#include <hardware/hardware.h>
#include <hardware/consumerir.h>

class ConsumerIRDevice : public QObject
{
    Q_OBJECT
public:
    explicit ConsumerIRDevice(QObject *parent = 0);
    ~ConsumerIRDevice();

    Q_PROPERTY(bool hasIR READ hasIR NOTIFY hasIRChanged)
    Q_INVOKABLE bool transmit(int carrierFrequency, const QList<int> pattern); //Using QList as data passed from QML

    bool hasIR();

signals:
    void hasIRChanged();

private:
    consumerir_device_t *m_dev = nullptr;
    bool m_hasIR = false;
};

#endif // CONSUMERIRDEVICE_H
