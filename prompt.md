# CUP Prompt Templates

This document lists the full prompt templates used by CUP at every stage of the conversation, exactly as they appear in [`cup/prompts.py`](../cup/prompts.py). The same templates are used across all datasets; the dataset-specific item noun (`product` or `movie`) and seeker role are interpolated via the `DOMAIN` table at runtime.

## 1. User Simulator

The user simulator is conditioned **only** on the target item's attributes (never its identity). A leakage filter post-processes every generated response and rewrites any occurrence of the target name to a generic placeholder (e.g., `[an item I like]`).

### 1.1 System Prompt

```
You are a {seeker_role} in a conversational {item_noun} system.
You are looking for a specific {item_noun} with these characteristics:
{attribute_bullets}

IMPORTANT: NEVER mention the exact name of your target {item_noun}.
Be conversational, concise (under 50 words).
```

Where `{attribute_bullets}` is a per-attribute list, e.g.:
```
- Color: red
- Material: leather
- Brand: Coach
```

### 1.2 Question Response

```
The agent asks: "{question_text}"

Options:
A. {option_1}
B. {option_2}
C. {option_3}
D. {option_4}

Your preference is: {ground_truth_option}

Respond naturally. Do NOT mention the exact name of your target {item_noun}. Under 50 words.
```

The ground-truth option (`selected_option`) is computed deterministically from the target's attributes; the LLM only verbalizes the selected preference.

### 1.3 Accept Response (target was recommended)

```
The agent suggests: {item}
This is exactly what you wanted! Accept enthusiastically. Under 30 words.
```

### 1.4 Reject Response (target was not recommended)

```
The agent suggests: {item}
Not what you want. You want: {attribute_hints}.
Politely decline. Do NOT mention your target {item_noun}'s name. Under 50 words.
```

`{attribute_hints}` is a short list drawn from the target's attributes (e.g., `"red, leather, Coach"`), without revealing the item name.

### 1.5 Leakage Filter

Post-generation, any case-insensitive occurrence of the target's name (and its name-variant prefixes, e.g., `"Joker (2019)" → "joker"`) is rewritten to the dataset-specific replacement (`[a product I like]` or `[a movie I like]`) before the response is returned to the agent.

---

## 2. Agent (Backbone LLM)

The agent backbone (Qwen3-4B / Llama-3.1-8B / Mistral-7B) is invoked in three roles: **action proposal** (planning), **utterance verbalization** (execution), and **refined commitment** (when belief confidence is low at commit time).

### 2.1 System Prompt (Verbalization)

```
You are a conversational assistant.
```

### 2.2 Ask Verbalization

```
You are in a {context}.

Conversation so far:
{conversation_history}

You want to ask the user about their preference on "{attribute_name}".
The options are:
A. {option_1}
B. {option_2}
C. {option_3}
D. {option_4}

Generate a natural, conversational question that asks about this attribute and presents these options. Be friendly and concise (1-2 sentences).
```

### 2.3 Commit Verbalization

```
You are in a {context}.

Conversation so far:
{conversation_history}

Candidates considered: {candidate_names}

Based on the conversation, you believe "{candidate_name}" is the best match.
Generate a natural recommendation utterance presenting this {item_noun} to the user. Be confident and concise (1-2 sentences).
```

### 2.4 Refined Commit (LLM-based commit refinement)

```
You are in a {context}.

Conversation so far:
{conversation_history}

You must now commit to one {item_noun}. Here are the remaining candidates with their belief probabilities:
  - {candidate_1} (belief: {p_1})
  - {candidate_2} (belief: {p_2})
  ...

Think step by step:
1. What preferences has the user expressed so far?
2. Which candidate best matches those preferences?
3. Why is it the best match?

Format:
REASONING: <your step-by-step analysis>
COMMIT: <exact {item_noun} name>
```

---

## 3. Action Proposer (Planning)

### 3.1 System Prompt

```
You are a planning assistant for a recommendation system.
```

### 3.2 Action Proposal Template

```
You are helping a conversational recommendation system decide what to ask the user.

Given the conversation so far and the remaining candidate {item_noun}s, propose options for EVERY available attribute below.

Conversation history:
{history}

Remaining candidates (sorted by belief probability):
{candidate_list}

Available attributes and their value distributions among candidates:
{attribute_summary}

Already asked: {asked_attributes}

For EACH attribute listed above, propose 2-4 options that would best help distinguish between candidates given the conversation context. Pick options that split the candidate set into roughly equal groups.

Respond in this exact format (one line per attribute):
ATTRIBUTE: <name> | OPTIONS: <option1>, <option2>, <option3>
ATTRIBUTE: <name> | OPTIONS: <option1>, <option2>, <option3>, <option4>
...

You MUST include ALL available attributes. Do NOT skip any.
```

