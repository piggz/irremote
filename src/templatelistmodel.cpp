#include "templatelistmodel.h"

#include <QStringList>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

TemplateListModel::TemplateListModel()
{
    QStringList locations = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);
    QStringList filter;

    filter << "*.irtemplate";

    foreach(QString location, locations) {
        qDebug() << "Looking in " << location;
        QDir d(location);
        QStringList entries = d.entryList(filter);
        foreach (QString entry, entries) {
            qDebug() << "Found " << entry;
            if (!m_templates.contains(entry)) {
                m_templates[entry] = QUrl::fromLocalFile(location + "/" + entry);
            }
        }
    }
}

int TemplateListModel::rowCount(const QModelIndex &parent) const
{
    return m_templates.count();
}

QVariant TemplateListModel::data(const QModelIndex &index, int role) const
{
    if (role == NameRole) {
        return m_templates.values().at(index.row()).fileName();
    } else if (role == PathRole) {
        return m_templates.values().at(index.row()).path();
    }
    return QVariant();
}

QHash<int, QByteArray> TemplateListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "templatename";
    roles[PathRole] = "path";
    return roles;
}
