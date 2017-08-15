#ifndef TEMPLATELISTMODEL_H
#define TEMPLATELISTMODEL_H

#include <QAbstractListModel>
#include <QUrl>

class TemplateListModel : public QAbstractListModel
{
public:
    TemplateListModel();
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual QHash<int, QByteArray> roleNames() const;

    enum TemplateRoles {
            NameRole = Qt::UserRole + 1,
            PathRole
        };

private:
    QHash<QString, QUrl> m_templates;

};

#endif // TEMPLATELISTMODEL_H
