🔧 How I Built a Modern Full Stack System with Rails and React from Scratch

Introduction:
In this post, I share how I designed and developed a fullstack system using Ruby on Rails for the backend and React for the frontend, built inside the same project while maintaining clean architecture and scalability.

Why this stack?
Ruby on Rails is still a robust framework for building strong APIs. React, on the other hand, enables rich and dynamic user interfaces. I chose to keep them conceptually separated, letting React own the frontend logic without forcing integration via ViewComponents.

Decision about ViewComponents:
Although the project has files compatible with ViewComponents, I decided not to use them in this case to avoid naming conflicts and logic duplication. React fully handles client-side logic and rendering, enhancing development speed and modularity.

SEO in client-side rendering:
SEO is often a weak point for client-side apps. I tackled this with React Helmet, dynamically managing metadata via useEffect and structured components. This provides decent SEO capabilities while keeping a fast dev cycle.

Architectural thoughts:
If the project were fully monolithic, I would definitely use ViewComponents and maybe Plex to manage interface types (HTML, JSON, protobuf) in a Domain-Driven Design context. But for hybrid or frontend-heavy projects, React remains my preferred approach for flexibility and team scalability.

Tech stack used:
• Ruby on Rails (API mode)
• React + Vite
• Authentication: Rodauth + OAuth2 + JWT
• Infrastructure: Docker + PostgreSQL
• Styling: CSS Modules + Tailwind
• SEO: React Helmet
• Testing: RSpec, Jest

Conclusion:
This project helped me build a structure that is modern, scalable, and easy to maintain. I’m open to technical feedback and eager to connect with fellow developers working with similar stacks.
