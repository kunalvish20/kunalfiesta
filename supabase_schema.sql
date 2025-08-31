-- Create the chats table
CREATE TABLE IF NOT EXISTS public.chats (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    owner_id UUID NOT NULL,
    project_id UUID,
    title TEXT NOT NULL DEFAULT 'New Chat',
    page_type TEXT NOT NULL DEFAULT 'home',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create the messages table
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    chat_id UUID NOT NULL REFERENCES public.chats(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    model TEXT,
    content_json JSONB,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_chats_owner_id ON public.chats(owner_id);
CREATE INDEX IF NOT EXISTS idx_chats_updated_at ON public.chats(updated_at);
CREATE INDEX IF NOT EXISTS idx_messages_chat_id ON public.messages(chat_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages(created_at);

-- Enable Row Level Security (RLS)
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for chats
CREATE POLICY "Users can view their own chats" 
    ON public.chats FOR SELECT 
    USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert their own chats" 
    ON public.chats FOR INSERT 
    WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update their own chats" 
    ON public.chats FOR UPDATE 
    USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete their own chats" 
    ON public.chats FOR DELETE 
    USING (auth.uid() = owner_id);

-- Create RLS policies for messages
CREATE POLICY "Users can view messages from their chats" 
    ON public.messages FOR SELECT 
    USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert messages to their chats" 
    ON public.messages FOR INSERT 
    WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update their own messages" 
    ON public.messages FOR UPDATE 
    USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete their own messages" 
    ON public.messages FOR DELETE 
    USING (auth.uid() = owner_id);
