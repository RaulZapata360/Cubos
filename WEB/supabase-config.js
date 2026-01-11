// ============================================
// SUPABASE CONFIGURATION - MULTI-ENVIRONMENT
// ============================================

// Detect if we're in a preview/development environment
const isPreview = window.location.hostname.includes('git-feature') ||
  window.location.hostname.includes('localhost') ||
  window.location.hostname.includes('127.0.0.1');

// Production Supabase (main branch)
const PROD_CONFIG = {
  url: 'https://rvnxnwotpieemwhbpoit.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2bnhud290cGllZW13aGJwb2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY4NDg5MTcsImV4cCI6MjA4MjQyNDkxN30.PkYOjzHcS_Tx8e40YkhcQDHrsf5cvHZ0H7jjQH63mwk'
};

// Development Supabase (preview deployments)
const DEV_CONFIG = {
  url: 'https://nevsvknqnzrkjngfbnxs.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ldnN2a25xbnpya2puZ2ZibnhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc1NTY3NjcsImV4cCI6MjA4MzEzMjc2N30.4YZ6o-mC0P2UIixKBwKjm9Vmr5gqH_EiYmPq5ovGdL0'
};

// Select configuration based on environment
const config = isPreview ? DEV_CONFIG : PROD_CONFIG;

export const supabaseConfig = {
  url: config.url,
  anonKey: config.anonKey
};

// Log which environment we're using (helpful for debugging)
console.log(`🔧 Supabase Environment: ${isPreview ? '🧪 DEVELOPMENT' : '🚀 PRODUCTION'}`);
console.log(`📍 URL: ${config.url}`);

// NOTA: La seguridad se maneja con Row Level Security (RLS) en Supabase

// ============================================
// GOOGLE MAPS CONFIGURATION
// ============================================
export const mapsConfig = {
  // Google Maps API Key
  apiKey: 'AIzaSyDefMPR_TwrfEXkfgtIwOMrWO0KAHx13jc',

  // Cache duration in minutes (default: 30 minutes)
  cacheDurationMinutes: 30,

  // Default fuel efficiency in km/L (used when truck doesn't have specific value)
  defaultFuelEfficiency: 3.5,

  // Enable/disable maps features (useful for development without API key)
  enabled: true // Maps features enabled
};
