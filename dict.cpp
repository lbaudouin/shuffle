#include "dict.h"

#include <QFile>
#include <QMap>
#include <QDebug>
#include <QDateTime>

static bool s_created = false;
static Dict *s_dict = NULL;


Dict::Dict() : m_gen(0), m_dis(0,1)
{

}

Dict* Dict::instance()
{
    if(!s_created){
        s_dict = new Dict();
        s_created = true;
    }
    return s_dict;
}

bool Dict::load(QString filepath)
{
    QFile file(filepath);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return false;
    }

    while (!file.atEnd()) {
        QByteArray line = file.readLine();
        if(line.contains("-"))
            continue;

        QString word = removeAccent(line).trimmed().toLower();

        if(word.size()>1){
            m_words << word;
        }
    }

    m_words.removeDuplicates();
    qDebug() << m_words.size();




    QMap<QChar,int> letters;

    for(int i=0;i<m_words.size();i++){
        m_wordsMap[ m_words.at(i).left(2) ] << m_words.at(i);

        //Count letters
        for(int j=0;j<m_words.at(i).size();j++){
            letters[m_words.at(i).at(j)] += 1;
        }
    }

    qDebug() << letters;

    m_letters.clear();
    m_nbLetters = 0;

    QMapIterator<QChar, int> i(letters);
    while (i.hasNext()) {
        i.next();
        m_nbLetters += i.value();

        m_letters << qMakePair<int,QChar>(i.value(),i.key());
    }

    qint64 seed = QDateTime::currentMSecsSinceEpoch();
    std::default_random_engine gen(seed);
    m_gen = gen;
    std::uniform_int_distribution<unsigned long long> dis(0,m_nbLetters);
    m_dis = dis;

    return true;
}

QString Dict::removeAccent(const QString &s)
{
    if (diacriticLetters.isEmpty()) {
        diacriticLetters = QString::fromUtf8("ŠŒŽšœžŸ¥µÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýÿ");
        noDiacriticLetters << "S"<<"OE"<<"Z"<<"s"<<"oe"<<"z"<<"Y"<<"Y"<<"u"<<"A"<<"A"<<"A"<<"A"<<"A"<<"A"<<"AE"<<"C"<<"E"<<"E"<<"E"<<"E"<<"I"<<"I"<<"I"<<"I"<<"D"<<"N"<<"O"<<"O"<<"O"<<"O"<<"O"<<"O"<<"U"<<"U"<<"U"<<"U"<<"Y"<<"s"<<"a"<<"a"<<"a"<<"a"<<"a"<<"a"<<"ae"<<"c"<<"e"<<"e"<<"e"<<"e"<<"i"<<"i"<<"i"<<"i"<<"o"<<"n"<<"o"<<"o"<<"o"<<"o"<<"o"<<"o"<<"u"<<"u"<<"u"<<"u"<<"y"<<"y";
    }

    QString output = "";
    for (int i = 0; i < s.length(); i++) {
        QChar c = s[i];
        int dIndex = diacriticLetters.indexOf(c);
        if (dIndex < 0) {
            output.append(c);
        } else {
            QString replacement = noDiacriticLetters[dIndex];
            output.append(replacement);
        }
    }

    return output;
}

QChar Dict::pickRandom()
{
    long rand = m_dis(m_gen);

    long pos = 0;
    QChar c;

    for(int j=0;j<m_letters.size();j++){
        pos += m_letters.at(j).first;

        if(rand<pos){
            c = m_letters.at(j).second;
            break;
        }

    }
    return c;
}

QList<QChar> Dict::pickRandom(int nb)
{
   QList<QChar> list;
   for(int i=0;i<nb;i++)
       list << pickRandom();
   return list;
}

QStringList Dict::words(QString prefix) const
{
    if(prefix.size()<2){
        return m_words;
    }
    return m_wordsMap.value( prefix.left(2) );
}

bool Dict::exists(const QString &word) const
{
    if(word.size()<2)
        return false;
    QString clean = word.trimmed().toLower();
    return m_wordsMap.value( clean.left(2) ).contains( clean );
}
