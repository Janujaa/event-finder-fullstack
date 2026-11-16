import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { Search, SlidersHorizontal } from 'lucide-react';
import api from '../services/api';
import EventCard from '../components/EventCard';

export default function Explore() {
  const [params] = useSearchParams();
  const [q, setQ] = useState(params.get('q') || '');
  const [category, setCategory] = useState(params.get('category') || '');
  const [date, setDate] = useState('');
  const [events, setEvents] = useState([]);
  const [cats, setCats] = useState([]);
  const [loading, setLoading] = useState(true);
  const [eventsError, setEventsError] = useState('');
  const [categoriesError, setCategoriesError] = useState('');

  useEffect(() => {
    const controller = new AbortController();
    api.get('/categories', { signal: controller.signal })
      .then(response => setCats(response.data))
      .catch(() => {
        if (!controller.signal.aborted) {
          setCategoriesError('Could not load event categories.');
        }
      });
    return () => controller.abort();
  }, []);

  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);
    setEventsError('');
    api.get('/events', {
      params: { q, categoryId: category, date },
      signal: controller.signal
    })
      .then(response => setEvents(response.data))
      .catch(() => {
        if (!controller.signal.aborted) {
          setEvents([]);
          setEventsError('Could not load events. Please try again.');
        }
      })
      .finally(() => {
        if (!controller.signal.aborted) setLoading(false);
      });
    return () => controller.abort();
  }, [q, category, date]);

  return (
    <main className="page-wrap">
      <div className="page-intro">
        <div className="eyebrow">THE GOOD STUFF IS OUT THERE</div>
        <h1>Explore events<span className="brand-dot">.</span></h1>
        <p>Find your next favourite thing to do.</p>
      </div>
      <div className="filter-bar">
        <div className="filter-search">
          <Search size={18} />
          <input
            placeholder="Search by event, location or keyword"
            value={q}
            onChange={event => setQ(event.target.value)}
          />
        </div>
        <select
          aria-label="Filter by category"
          value={category}
          onChange={event => setCategory(event.target.value)}
        >
          <option value="">All categories</option>
          {cats.map(item => (
            <option key={item.id} value={item.id}>{item.name}</option>
          ))}
        </select>
        <input
          aria-label="Filter by date"
          type="date"
          value={date}
          onChange={event => setDate(event.target.value)}
        />
      </div>
      {categoriesError && <p className="form-error" role="alert">{categoriesError}</p>}
      <div className="results-heading">
        <b>{loading ? 'Finding events...' : `${events.length} events found`}</b>
        <span><SlidersHorizontal size={15} /> Curated for discovery</span>
      </div>
      <div className="event-grid">
        {events.map(event => <EventCard event={event} key={event.id} />)}
      </div>
      {eventsError && <div className="form-error" role="alert">{eventsError}</div>}
      {!loading && !eventsError && !events.length && (
        <div className="empty-state">
          No events match your search. Try another keyword or clear the filters.
        </div>
      )}
    </main>
  );
}
