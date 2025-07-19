-- Supabase Reading List Setup
-- Run this in your Supabase SQL Editor

-- Create the books table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.books (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    author TEXT,
    url TEXT,
    status TEXT DEFAULT 'unread' CHECK (status IN ('unread', 'reading', 'finished')),
    notes TEXT,
    inserted_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Users can view their own books" ON public.books;
DROP POLICY IF EXISTS "Users can insert their own books" ON public.books;
DROP POLICY IF EXISTS "Users can update their own books" ON public.books;
DROP POLICY IF EXISTS "Users can delete their own books" ON public.books;

-- Create RLS policies
CREATE POLICY "Users can view their own books" ON public.books
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own books" ON public.books
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own books" ON public.books
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own books" ON public.books
FOR DELETE USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_books_user_id ON public.books(user_id);
CREATE INDEX IF NOT EXISTS idx_books_inserted_at ON public.books(inserted_at DESC);
CREATE INDEX IF NOT EXISTS idx_books_status ON public.books(status);

-- Grant necessary permissions
GRANT ALL ON public.books TO authenticated;
GRANT USAGE ON SCHEMA public TO authenticated; 