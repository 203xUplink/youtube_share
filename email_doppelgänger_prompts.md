**Prompt 1: Parsing Emails**
WARNING: Using public LLMs on raw email data may violate GDPR or privacy policies. Use either a **local LLM** for style extraction or ensure all emails are **strictly anonymized** before processing.

System Task: Email Style & Knowledge Extraction
Subject: [Your Title/Name] ([Your Organization])
Source Data: [Path to your sent emails]/

Objective:
Create two distinct Markdown files (style_guide.md and response_knowledge_base.md) based on the analysis of the user's email corpus.

File 1: `style_guide.md` (Style Definition)
 * Purpose: To teach an LLM how to sound exactly like the user.
 * Structure:
     * Section A: Primary Language Style
         * Tone: Pragmatic, efficient, "short & sweet".
         * Greetings/Sign-offs: Specific usage (e.g., "Best, [Your Name]", "Hi [First Name]").
         * Formatting: Usage of bullet points, bold text, and paragraph length.
     * Section B: Secondary Language Style (if applicable)
         * Tone: Professional but direct.
         * Greetings/Sign-offs: Specific usage.
     * Section C: General Formatting Rules
         * No fluff, no filler sentences.
         * Preference for resolving issues in the first sentence.

File 2: `response_knowledge_base.md` (Logic & Templates)
 * Purpose: A retrieval-optimized database for an LLM to decide what to answer.
 * Format: Structured data (Intent -> Context/Conditions -> Content Points).
 * Constraint: Strictly mimic the user's brevity.
 * Structure:
     * Section A: Common Scenarios
         * Example: Inquiry about [Topic A] -> User's Standard Action: [Standard response logic/action].
         * Example: Request for [Item B] -> User's Standard Action: [Standard response logic/action].


**Prompt 2: App Construction**

Build a single-file Python Streamlit application named `app.py` that acts as an 'Email Doppelgänger'.

**Core Architecture:**
1.  **Style Engine:** On startup, check if `style_guide.md` exists. If not, create it with this content: *'Style: Direct, concise, no fluff. Use bullet points for tasks. Sign off with 'Best, [Your Name]'. Tone: Professional but efficient.'*
2.  **Privacy Middleware (The Hook):** Implement a function `redact_pii(text)` that uses Regex to find all names (e.g., following 'Hi', 'Dear', 'Mr.', 'Ms.', 'BR') and replaces them with `[MASKED_ENTITY]` to protect privacy. Implement `restore_pii` to swap them back after generation. Display this swapping process in the UI (e.g., 'Sanitizing...' toast). Also have a possibility to show the privatized email.
3.  **Response Option Selector:** After the user pastes an email, use a quick LLM call to analyze it and present 3 radio buttons for potential response angles. These radio buttons only appears if the email was read by the quick llm and it was suggested something specific to the email.
4. Have a button to look an answer up in the file response_knowledge_base.md that is in the same folder. The llm should read that md file to find a similar answer. This similar answer should then presented as a snippet to the user that is then saying green/red light.
5.  **Dual-Engine Logic:**
    *   **Cloud:** Use `openai` client, api key in environment variables. OPENAI_API_KEY is in path.
    *   **Local:** Use `requests` to hit a local Ollama endpoint. Ensure the startup script handles the Ollama server.
6.  **UI Design (Glassmorphism):** Inject custom CSS (`st.markdown`) to make the sidebar and main container semi-transparent with a blur backdrop filter (`backdrop-filter: blur(10px)`), dark background, modern minimal look.
7.  **Deployment:** Generate a `run.sh` script that:
    *   Checks if Ollama is running (starts it if not).
    *   Installs `streamlit openai`.
    *   Runs the Streamlit app.
8. Test everything you can. The app should throw no errors

**User Flow:**
*   User pastes an incoming email.
*   **App suggests 3 response angles.** User selects one or have the llm check potential answers in response_knowledge_base.md
*   User selects 'Model: Llama3 (Local)' or 'GPT-4o'.
*   Click 'Generate Response'.
*   Show the **Redacted Prompt** in an expander (to prove privacy).
*   Stream the output.
