import { Injectable } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";

@Injectable()
export class AreasService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.area.findMany({ where: { isActive: true }, orderBy: { baseFee: "asc" } });
  }

  async calculateFee(distanceKm: number): Promise<number> {
    const areas = await this.prisma.area.findMany({
      where: { isActive: true },
      orderBy: { maxDistance: "asc" },
    });
    const area = areas.find((a) => distanceKm <= a.maxDistance);
    return area ? area.baseFee : (areas[areas.length - 1]?.baseFee ?? 15000);
  }
}
