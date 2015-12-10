#ifndef GRID_H
#define GRID_H

#include <QList>
#include <QChar>
#include <QStringList>
#include <QSize>

#include "tile.h"

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>

struct Solution{
    Solution(QString w, QList<int> m) : word(w), moves(m) { }
    QString word;
    QList<int> moves;
};

typedef QList<Solution> SolutionList;

class Solutions{
public:
    Solutions();
    QStringList toStringList() const {
        QStringList list;
        for(int i=0;i<m_solutions.size();i++)
            list << m_solutions.at(i).word;
        return list;
    }
private:
    QList<Solution> m_solutions;
};


class Grid : public QObject
{
    Q_OBJECT
public:
    Grid(int x, int y);
    Grid(QSize size);
    Grid(const Grid *grid);


    Q_PROPERTY(int columns READ columns NOTIFY columnsChanged)
    Q_PROPERTY(int rows READ rows NOTIFY rowsChanged)

    int columns() const;
    int rows() const;


    int sizeInt() const;
    QSize size() const;

    void setValues( const QList<QChar> &list );
    void setValues( const QList<Tile> &list );

    void setVisited(int tile);

    void display() const;

    void setWords( const QStringList &words);


    SolutionList solve() const;
    SolutionList solve(int tile, QString word, const QStringList &words, QList<int> moves) const;
    SolutionList removeDuplicates(const SolutionList &solutions) const;

protected:
    QList<Tile> tiles() const;

private:
    QSize m_size;
    QList<Tile> m_tiles;
    SolutionList m_solutions;

public slots:
    QJsonArray getTilesJS() const;
    void generate();

    bool exists(QString word) const;

    void displaySolutions();

signals:
    void generated();
    void results(QJsonObject results);

    void columnsChanged(int columns);
    void rowsChanged(int rows);
};

#endif // GRID_H
