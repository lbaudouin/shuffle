#include "grid.h"
#include <QDebug>
#include <QRegExp>

#include "dict.h"

bool longestFirst(const Solution &s1, const Solution &s2)
{
    return s1.word.size() > s2.word.size();
}


Grid::Grid(int x, int y) : Grid( QSize(x,y) )
{
}

Grid::Grid(QSize size) : m_size(size)
{

}

Grid::Grid(const Grid *grid) : m_size(grid->size())
{
    m_tiles = grid->tiles();
}

int Grid::sizeInt() const
{
    return m_size.width() * m_size.height();
}

QSize Grid::size() const
{
    return m_size;
}

void Grid::setValues(const QList<QChar> &list)
{
    m_tiles.clear();
    if(list.size()!=this->sizeInt()){
        qDebug() << "Wrong size";
        m_tiles.reserve(this->sizeInt());
        return;
    }

    for(int i=0;i<list.size();i++){
        int x = i%m_size.width();
        int y = i/m_size.width();
        m_tiles << Tile(x,y,list.at(i));
    }
}

void Grid::setValues(const QList<Tile> &list)
{
    m_tiles.clear();
    if(list.size()!=this->sizeInt()){
        qDebug() << "Wrong size";
        m_tiles.reserve(this->sizeInt());
        return;
    }
    m_tiles = list;
}

void Grid::display() const
{
    QString line;
    for(int c=0;c<m_size.width();c++)
        line += "_";
    //qDebug() << line;
    for(int r=0;r<m_size.height();r++){
        QString s;
        for(int c=0;c<m_size.width();c++)
            s += m_tiles.at(r*m_size.width() + c).c();
        qDebug() << s;
    }
}

SolutionList Grid::removeDuplicates(const SolutionList &solutions) const
{
    QStringList temp;
    SolutionList out;

    for(int i=0;i<solutions.size();i++){
        if(!temp.contains(solutions.at(i).word)){
            temp << solutions.at(i).word;
            out << solutions.at(i);
        }
    }

    return out;
}

SolutionList Grid::solve() const
{
    QList<int> moves;

    QStringList words;

    SolutionList sol = removeDuplicates(this->solve(-1,"",words,moves));

    qSort(sol.begin(),sol.end(),longestFirst);

    return sol;
}

SolutionList Grid::solve(int tile, QString word, const QStringList &words, QList<int> moves) const
{
    //qDebug() << tile << word << words.size();
    SolutionList solutions;
    int size = this->sizeInt();
    for(int i=0;i<size;i++){
        if(i==tile){
            continue;
        }

        if(m_tiles.at(i).visited())
            continue;

        if(tile>=0){
            if(!m_tiles.at(i).near( m_tiles.at(tile) )){
                continue;
            }
        }

        QList<int> m = moves;
        m << i;

        QString w = word + m_tiles.at(i).c();


        QStringList filtered;
        if(w.size()<2){

        }else{
            if(w.size()==2){
                filtered = Dict::instance()->words(w);
            }else{
                filtered = words.filter(QRegExp("^" + w));
            }

            if(filtered.size()==0){
                continue;
            }
        }

        for(int k=0;k<filtered.size();k++){
            if(w == filtered.at(k)){
                //qDebug() << w << m;
                solutions << Solution(w,m);
            }
        }

        Grid g(this);

        g.setVisited(i);

        solutions << g.solve(i,w,filtered,m);
    }
    return solutions;
}

 QList<Tile> Grid::tiles() const
 {
     return m_tiles;
 }

void Grid::setVisited(int tile)
{
    if(tile>=0 && tile<m_tiles.size()){
        m_tiles[tile].setVisited();
    }
}

QJsonArray Grid::getTilesJS() const
{
    QJsonArray a;
    for(int i=0;i<m_tiles.size();i++){
        a.append( m_tiles.at(i).getTileJS() );
    }
    return a;
}

void Grid::generate()
{
    m_solutions.clear();
    this->setValues( Dict::instance()->pickRandom(this->sizeInt()) );
    this->display();
    m_solutions = this->solve();
    for(int i=0;i<m_solutions.size();i++){
        qDebug() << m_solutions.at(i).word;
    }
    emit generated();
}

bool Grid::exists(QString word) const
{
    for(int i=0;i<m_solutions.size();i++){
        if( m_solutions.at(i).word == word )
            return true;
    }
    return false;
}