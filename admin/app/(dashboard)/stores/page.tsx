"use client";
import { useEffect, useState } from "react";
import { api } from "@/lib/api";

export default function StoresPage() {
  const [stores, setStores] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/stores").then(setStores).finally(() => setLoading(false));
  }, []);

  return (
    <div className="space-y-4">
      {loading ? (
        <div className="text-center py-20 text-gray-400">Memuat...</div>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {stores.map((store) => (
            <div key={store.id} className="bg-white border rounded-2xl p-5 hover:shadow-md transition">
              <div className="flex items-start justify-between mb-3">
                <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center text-xl">🏪</div>
                <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${store.isActive ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}`}>
                  {store.isActive ? "Aktif" : "Nonaktif"}
                </span>
              </div>
              <h3 className="font-semibold text-gray-800">{store.name}</h3>
              <p className="text-sm text-gray-500 mt-1">{store.description}</p>
              <p className="text-xs text-gray-400 mt-2">📍 {store.address}</p>
              {store._count && (
                <p className="text-xs text-blue-600 mt-2 font-medium">{store._count.products} produk</p>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
