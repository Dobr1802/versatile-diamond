#include "saving_queue.h"

namespace vd
{

void SavingQueue::push(QueueItem *item, double allTime, double currentTime, const char *name)
{
    item->copyData();
    _queue.push(new qitem({item, allTime, currentTime, name}));
    pthread_cond_signal(&_cond);
}

void SavingQueue::run()
{
    while (!_stopSave)
    {
        pthread_mutex_lock(&_mutex);

        process();
        pthread_cond_wait(&_cond, &_mutex);

        pthread_mutex_unlock(&_mutex);
    }
    process();
    stopThread();
}

void SavingQueue::process()
{
    while (!_queue.empty())
    {
        qitem* qi = _queue.front();
        qi->item->saveData(qi->allTime, qi->currentTime, qi->name);
        _queue.pop();
        delete qi;
    }
}

void SavingQueue::stopSave()
{
    _stopSave = true;
}

}