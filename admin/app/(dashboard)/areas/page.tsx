"use client";
import { useEffect, useState } from "react";
import { api } from "@/lib/api";

function fmt(n: number) {
  return new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR", maximumFractionDigits: 0 }).format(n);
}

export default function AreasPage() {
  const [areas, setAreas] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/areas").then(setAreas).finally(() => setLoading(false));
  }, []);

  return (
    <div className="space-y-4">
      {loading ? (
        <div className="text-center py-20 text-gray-400">Memuat...</div>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {areas.map((area) => (
            <div key={area.id} className="bg-white border rounded-2xl p-5">
              <div className="flex items-center gap-3 mb-3">
                <span className="text-2xl">📍</span>
                <span className={`ml-auto px-2 py-0.5 rounded-full text-xs font-medium ${area.isActive ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}`}>
                  {area.isActive ? "Aktif" : "Nonaktif"}
                </span>
              </div>
              <h3 className="font-semibold text-gray-800">{area.name}</h3>
              {area.description && <p className="text-sm text-gray-500 mt-1">{area.description}</p>}
              <div className="mt-3 flex gap-4 text-sm">
                <span className="text-gray-500">Max: <b className="text-gray-700">{area.maxDistance} km</b></span>
                <span className="text-gray-500">Fee: <b className="text-blue-600">{fmt(area.baseFee)}</b></span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
