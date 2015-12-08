#include "tile.h"

#include <QMap>
#include <QJsonValue>
#include <QVariant>

static QMap<QChar,int> letterPoints;

void populate()
{
    letterPoints.clear();
    letterPoints['a'] = 1;
    letterPoints['b'] = 3;
    letterPoints['c'] = 3;
    letterPoints['d'] = 2;
    letterPoints['e'] = 1;
    letterPoints['f'] = 4;
    letterPoints['g'] = 2;
    letterPoints['h'] = 4;
    letterPoints['i'] = 1;
    letterPoints['j'] = 8;
    letterPoints['k'] = 10;
    letterPoints['l'] = 1;
    letterPoints['m'] = 2;
    letterPoints['n'] = 1;
    letterPoints['o'] = 1;
    letterPoints['p'] = 3;
    letterPoints['q'] = 8;
    letterPoints['r'] = 1;
    letterPoints['s'] = 1;
    letterPoints['t'] = 1;
    letterPoints['u'] = 1;
    letterPoints['v'] = 4;
    letterPoints['w'] = 10;
    letterPoints['x'] = 10;
    letterPoints['y'] = 10;
    letterPoints['z'] = 10;
}

Tile::Tile(int x, int y, QChar c) : Tile(QPoint(x,y),c)
{
}

Tile::Tile(QPoint pt, QChar c) : m_pt(pt), m_c(c), m_visited(false)
{

}

QPoint Tile::pos() const
{
    return m_pt;
}

QChar Tile::c() const
{
    return m_c;
}

bool Tile::visited() const
{
    return m_visited;
}

void Tile::setVisited()
{
    m_visited = true;
}

bool Tile::nearFrom(const Tile &tile) const
{
    if(this->pos()==tile.pos())
        return false;

    int dx = this->pos().x() - tile.pos().x();
    int dy = this->pos().y() - tile.pos().y();

    if(qAbs(dx)<=1 && qAbs(dy)<=1)
        return true;

    return false;
}

QJsonObject Tile::getTileJS() const
{
    int pts = pointsForLetter(m_c);
    QJsonObject o;
    o.insert("letter", QJsonValue::fromVariant(QString(m_c)));
    o.insert("points", QJsonValue::fromVariant(pts));
    return o;
}

int Tile::pointsForLetter(const QChar &c)
{
    if(letterPoints.isEmpty()) populate();
    return letterPoints.value(c);
}
