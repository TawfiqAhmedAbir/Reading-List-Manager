export interface Book {
  id: string;
  user_id: string;
  title: string;
  author?: string;
  url?: string;
  status: 'unread' | 'reading' | 'finished';
  notes?: string;
  inserted_at: string;
}

export interface CreateBookData {
  title: string;
  author?: string;
  url?: string;
  notes?: string;
}

export interface UpdateBookData {
  title?: string;
  author?: string;
  url?: string;
  status?: 'unread' | 'reading' | 'finished';
  notes?: string;
} 