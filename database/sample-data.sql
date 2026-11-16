USE event_finder;

-- Register an account in the app before running this script. The sample events
-- will be owned by the first registered user, avoiding a seeded password.
INSERT IGNORE INTO categories (name)
VALUES
    ('Technology'),
    ('Music'),
    ('Business'),
    ('Arts & Culture'),
    ('Sports'),
    ('Education'),
    ('Food & Lifestyle'),
    ('Community');

SET @sample_organiser_id := (SELECT id FROM users ORDER BY id LIMIT 1);

INSERT INTO events (
    title,
    description,
    category_id,
    event_date,
    start_time,
    end_time,
    venue,
    location,
    image_url,
    organiser_name,
    organiser_email,
    capacity,
    created_by
)
SELECT
    demo.title,
    demo.description,
    category.id,
    demo.event_date,
    demo.start_time,
    demo.end_time,
    demo.venue,
    demo.location,
    demo.image_url,
    organiser.name,
    organiser.email,
    demo.capacity,
    organiser.id
FROM (
    SELECT
        'Full Stack Web Development Workshop' AS title,
        'A hands-on workshop covering modern frontend development, REST APIs, and database-backed application design. Suitable for students who know basic programming.' AS description,
        'Technology' AS category_name,
        DATE '2026-12-05' AS event_date,
        TIME '09:30:00' AS start_time,
        TIME '16:30:00' AS end_time,
        'Innovation Lab, IIT Madras Research Park' AS venue,
        'Chennai' AS location,
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80' AS image_url,
        80 AS capacity
    UNION ALL SELECT
        'AI and Machine Learning Bootcamp',
        'An introductory bootcamp exploring practical machine learning workflows, responsible AI, and small guided Python projects.',
        'Education',
        DATE '2026-12-12',
        TIME '10:00:00',
        TIME '17:00:00',
        'Taramani Knowledge Centre',
        'Chennai',
        'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=900&q=80',
        60
    UNION ALL SELECT
        'Hackathon 2026 - SRM Campus',
        'A friendly 24-hour student hackathon focused on useful civic and campus ideas. Teams will build prototypes, get mentor feedback, and present their work.',
        'Community',
        DATE '2026-12-19',
        TIME '09:00:00',
        TIME '18:00:00',
        'Tech Park, SRM Institute of Science and Technology',
        'Kattankulathur, Chennai',
        'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=900&q=80',
        120
    UNION ALL SELECT
        'UI/UX Design Masterclass',
        'Learn user research, wireframing, prototyping, and accessibility basics through a collaborative redesign exercise.',
        'Arts & Culture',
        DATE '2027-01-09',
        TIME '10:00:00',
        TIME '15:30:00',
        'The Hive, Anna Nagar',
        'Chennai',
        'https://images.unsplash.com/photo-1561070791-2526d30994b5?auto=format&fit=crop&w=900&q=80',
        45
    UNION ALL SELECT
        'Startup and Entrepreneurship Meetup',
        'Local founders and aspiring entrepreneurs share lessons on validating an idea, finding early customers, and building a sustainable startup.',
        'Business',
        DATE '2027-01-16',
        TIME '17:30:00',
        TIME '20:00:00',
        'WeWork, DLF Cybercity',
        'Chennai',
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=900&q=80',
        70
    UNION ALL SELECT
        'Cybersecurity Awareness Seminar',
        'A practical introduction to phishing prevention, account security, privacy, and safe computing habits for students and early-career professionals.',
        'Education',
        DATE '2027-01-23',
        TIME '14:00:00',
        TIME '17:00:00',
        'C-DAC Chennai Auditorium',
        'Taramani, Chennai',
        'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=900&q=80',
        100
    UNION ALL SELECT
        'Photography and Creative Arts Workshop',
        'Practice composition, natural-light photography, and visual storytelling in a welcoming workshop for beginners and hobbyists.',
        'Arts & Culture',
        DATE '2027-02-06',
        TIME '09:00:00',
        TIME '13:00:00',
        'DakshinaChitra Heritage Museum',
        'Muttukadu, Chennai',
        'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?auto=format&fit=crop&w=900&q=80',
        35
    UNION ALL SELECT
        'Tech Career and Internship Fair',
        'Meet technology teams, learn about internships and entry-level roles, and join short sessions on portfolios and interview preparation.',
        'Business',
        DATE '2027-02-13',
        TIME '10:00:00',
        TIME '16:00:00',
        'Chennai Trade Centre',
        'Nandambakkam, Chennai',
        'https://images.unsplash.com/photo-1521737711867-e3b97375f902?auto=format&fit=crop&w=900&q=80',
        250
    UNION ALL SELECT
        'Sustainable Innovation and Green Technology Seminar',
        'Explore practical renewable-energy, waste-reduction, and sustainable-design projects with local researchers and community groups.',
        'Technology',
        DATE '2027-02-20',
        TIME '10:00:00',
        TIME '13:30:00',
        'Anna Centenary Library',
        'Kotturpuram, Chennai',
        'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=900&q=80',
        90
    UNION ALL SELECT
        'React.js Developer Community Meetup',
        'An informal meetup featuring short React talks, practical component patterns, and time to connect with Chennai frontend developers.',
        'Community',
        DATE '2027-03-06',
        TIME '10:00:00',
        TIME '13:00:00',
        'IIT Madras Research Park, Seminar Hall 2',
        'Taramani, Chennai',
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=900&q=80',
        75
) AS demo
JOIN categories AS category ON category.name = demo.category_name
JOIN users AS organiser ON organiser.id = @sample_organiser_id
WHERE NOT EXISTS (
    SELECT 1
    FROM events AS existing
    WHERE existing.title = demo.title
      AND existing.event_date = demo.event_date
);

SELECT CASE
    WHEN @sample_organiser_id IS NULL
        THEN 'No registered user found. Register an account, then run this script again.'
    ELSE 'Demo event seed completed; existing matching title/date records were left unchanged.'
END AS seed_status;
