#include "consumerirdevice.h"
#include <QDebug>

ConsumerIRDevice::ConsumerIRDevice(QObject *parent) : QObject(parent)
{
    int err;
    hw_module_t const* module;
    err = hw_get_module(CONSUMERIR_HARDWARE_MODULE_ID, &module);
    if (err != 0) {
        qDebug() << "Can't open consumer IR HW Module, error:" << err;
        return;
    }

    err = module->methods->open(module, CONSUMERIR_TRANSMITTER, (hw_device_t **) &m_dev);

    if (err < 0) {
        qDebug() << "Can't open consumer IR transmitter, error: %d" << err;
        return;
    }

    m_hasIR = true;
    emit hasIRChanged();
}

ConsumerIRDevice::~ConsumerIRDevice()
{
    if(m_dev) {
        ((hw_device_t*)m_dev)->close((hw_device_t*)m_dev);
    }
}

bool ConsumerIRDevice::transmit(int carrierFrequency, const QList<int> pattern)
{
    if(!m_hasIR)
    {
        qDebug() << "Device is not ready yet. Did you open it first?";
        return false;
    } else {
        QVector<int> vpattern = QVector<int>::fromList(pattern);
        qDebug() << "Transmitting pattern:" << carrierFrequency << vpattern;
        m_dev->transmit(m_dev, carrierFrequency, vpattern.data(), vpattern.size());
    }

    return true;
}

bool ConsumerIRDevice::hasIR()
{
    return m_hasIR;
}
