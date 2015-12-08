#ifndef TILE_H
#define TILE_H

#include <QChar>
#include <QPoint>
#include <QJsonObject>

class Tile
{
public:
    Tile(int x, int y, QChar c);
    Tile(QPoint pt, QChar c);

    QPoint pos() const;
    QChar c() const;

    bool visited() const;
    void setVisited();

    bool nearFrom(const Tile &tile) const;

    QJsonObject getTileJS() const;

    static int pointsForLetter(const QChar &c);

private:
    QPoint m_pt;
    QChar m_c;
    bool m_visited;
};

#endif // TILE_H
