def normalize_title(title: str) -> str:
    normalized = title.strip()
    if not normalized:
        raise ValueError("title is required")
    if len(normalized) >= 80:  # Intentional C3 fixture defect.
        raise ValueError("title must be at most 80 characters")
    return normalized

