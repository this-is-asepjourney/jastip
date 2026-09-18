import { CategoriesService } from "./categories.service";
export declare class CategoriesController {
    private categoriesService;
    constructor(categoriesService: CategoriesService);
    findAll(): Promise<({
        _count: {
            products: number;
        };
    } & {
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        image: string | null;
        isActive: boolean;
    })[]>;
    findOne(id: string): Promise<{
        products: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            image: string | null;
            description: string;
            price: number;
            stock: number;
            isAvailable: boolean;
            storeId: string;
            categoryId: string | null;
        }[];
    } & {
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        image: string | null;
        isActive: boolean;
    }>;
}
