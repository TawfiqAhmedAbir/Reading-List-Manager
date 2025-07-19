import { supabase } from './supabaseClient';
import type { Book, CreateBookData, UpdateBookData } from '../types/book';

export const getBooks = async (): Promise<Book[]> => {
  const { data, error } = await supabase
    .from('books')
    .select('*')
    .order('inserted_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
};

export const getBooksByStatus = async (status: string): Promise<Book[]> => {
  const { data, error } = await supabase
    .from('books')
    .select('*')
    .eq('status', status)
    .order('inserted_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
};

export const createBook = async (bookData: CreateBookData): Promise<Book> => {
  // Get the current user
  const { data: { user }, error: userError } = await supabase.auth.getUser();
  
  if (userError || !user) {
    throw new Error('User not authenticated');
  }

  const { data, error } = await supabase
    .from('books')
    .insert([{ 
      ...bookData, 
      user_id: user.id,
      status: 'unread' 
    }])
    .select()
    .single();
  
  if (error) throw error;
  return data;
};

export const updateBook = async (id: string, bookData: UpdateBookData): Promise<Book> => {
  const { data, error } = await supabase
    .from('books')
    .update(bookData)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw error;
  return data;
};

export const deleteBook = async (id: string): Promise<void> => {
  const { error } = await supabase
    .from('books')
    .delete()
    .eq('id', id);
  
  if (error) throw error;
}; 