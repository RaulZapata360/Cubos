// ============================================
// SUPABASE CONFIGURATION - PROYECTO ACTIVO
// ============================================

export const supabaseConfig = {
  url: 'https://rvnxnwotpieemwhbpoit.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2bnhud290cGllZW13aGJwb2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY4NDg5MTcsImV4cCI6MjA4MjQyNDkxN30.PkYOjzHcS_Tx8e40YkhcQDHrsf5cvHZ0H7jjQH63mwk'
};

// NOTA: La seguridad se maneja con Row Level Security (RLS) en Supabase

// ============================================
// GOOGLE MAPS CONFIGURATION
// ============================================
export const mapsConfig = {
  // TODO: Replace with your Google Maps API Key
  // Get it from: https://console.cloud.google.com/
  apiKey: 'YOUR_GOOGLE_MAPS_API_KEY_HERE',

  // Cache duration in minutes (default: 30 minutes)
  cacheDurationMinutes: 30,

  // Default fuel efficiency in km/L (used when truck doesn't have specific value)
  defaultFuelEfficiency: 3.5,

  // Enable/disable maps features (useful for development without API key)
  enabled: false // Set to true once you have an API key
};
