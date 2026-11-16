import { useState } from 'react';
import { Link, NavLink, useNavigate } from 'react-router-dom';
import { CalendarDays, LogOut, Menu, UserRound, X } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import './navigation.css';

export default function Navbar() {
  const { user, logout } = useAuth();
  const [menuOpen, setMenuOpen] = useState(false);
  const navigate = useNavigate();
  const closeMenu = () => setMenuOpen(false);

  return (
    <header className="nav">
      <Link className="brand" to="/" onClick={closeMenu}>
        <span className="brand-mark"><CalendarDays size={19} /></span>
        evently<span className="brand-dot">.</span>
      </Link>
      <nav id="primary-navigation" className={`nav-menu${menuOpen ? ' is-open' : ''}`}>
        <NavLink to="/explore" onClick={closeMenu}>Explore</NavLink>
        <a href="/#categories" onClick={closeMenu}>Categories</a>
      </nav>
      <div className="nav-actions">
        {user ? (
          <>
            <Link className="nav-link" to="/dashboard">
              <UserRound size={17} />Dashboard
            </Link>
            <button
              className="btn btn-dark btn-small"
              onClick={() => { logout(); closeMenu(); navigate('/'); }}
            >
              <LogOut size={15} />Log out
            </button>
          </>
        ) : (
          <>
            <Link className="nav-link" to="/login">Log in</Link>
            <Link className="btn btn-dark btn-small" to="/register">
              Get started <span>↗</span>
            </Link>
          </>
        )}
        <button
          type="button"
          className="nav-toggle"
          aria-label={menuOpen ? 'Close navigation menu' : 'Open navigation menu'}
          aria-controls="primary-navigation"
          aria-expanded={menuOpen}
          onClick={() => setMenuOpen(open => !open)}
        >
          {menuOpen ? <X size={20} /> : <Menu size={20} />}
        </button>
      </div>
    </header>
  );
}