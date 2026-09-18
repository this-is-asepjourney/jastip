const BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/api";

function getToken() {
  if (typeof window === "undefined") return null;
  return localStorage.getItem("admin_token");
}

async function request(path: string, options: RequestInit = {}) {
  const token = getToken();
  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: res.statusText }));
    throw new Error(err.message || "Request failed");
  }
  return res.json();
}

export const api = {
  get: (path: string) => request(path),
  post: (path: string, data: unknown) =>
    request(path, { method: "POST", body: JSON.stringify(data) }),
  put: (path: string, data: unknown) =>
    request(path, { method: "PUT", body: JSON.stringify(data) }),
  delete: (path: string) => request(path, { method: "DELETE" }),
};

export function setAdminToken(token: string) {
  localStorage.setItem("admin_token", token);
}

export function clearAdminToken() {
  localStorage.removeItem("admin_token");
}

export function isAdminLoggedIn() {
  return !!getToken();
}
