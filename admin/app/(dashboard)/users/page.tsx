"use client";
import { useEffect, useState } from "react";
import { api } from "@/lib/api";

export default function UsersPage() {
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Note: Admin needs a /admin/users endpoint. For now show a placeholder.
    setLoading(false);
  }, []);

  return (
    <div className="bg-white rounded-2xl border p-8 text-center text-gray-400">
      <div className="text-4xl mb-4">👤</div>
      <p className="font-medium text-gray-600">Manajemen Customer</p>
      <p className="text-sm mt-2">Tambahkan endpoint <code className="bg-gray-100 px-1 rounded">/admin/users</code> di backend untuk mengelola customer.</p>
    </div>
  );
}
