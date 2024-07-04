<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RollsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('rolls')->insert([
            [
                'id'=>1,
                'name' => 'admin'
            ],
            [
                'id'=>2,
                'name' => 'country_manager'
            ],
            [
                'id'=>3,
                'name' => 'delivery'
            ],
            // Add more rolls as needed
        ]);
    }
}
