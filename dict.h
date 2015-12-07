#ifndef DICT_H
#define DICT_H

#include <QString>
#include <QStringList>
#include <QPair>
#include <random>
#include <QMap>

class Dict
{
public:
    static Dict *instance();

    bool load(QString filepath);

    QString removeAccent(const QString &s);

    QChar pickRandom();
    QList<QChar> pickRandom(int nb);

    QStringList words(QString prefix = QString()) const;
    bool exists(const QString &word) const;

protected:
    QString diacriticLetters;
    QStringList noDiacriticLetters;

private:
    Dict();

    QStringList m_words;
    QMap<QString,QStringList> m_wordsMap;

    QList< QPair<int,QChar> > m_letters;
    int m_nbLetters;

    std::default_random_engine m_gen;
    std::uniform_int_distribution<unsigned long long> m_dis;

};

#endif // DICT_H
