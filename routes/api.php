<?php

use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\AdvertisementController;
use App\Http\Controllers\Api\BillController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\StroesController;
use App\Http\Controllers\Api\CartController;

use App\Http\Controllers\Api\AplicationVersionController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
// get,insert,update,delete category

//ارجاع جميع الفئات التي تنتمي لدولة معينة
Route::get('/category/{country}', [CategoryController::class, 'index']);
//حفظ فئة جديدة
Route::post('/insert/category', [CategoryController::class, 'store']);
Route::post('/update/category', [CategoryController::class, 'update']);
Route::post('/delete/category', [CategoryController::class, 'destroy']);

// get,insert,update,delete produc
Route::get('/product/{category_id}', [ProductController::class, 'index']);
Route::post('/insert/product', [ProductController::class, 'store']);
Route::post('/update/product', [ProductController::class, 'update']);
Route::post('/delete/product', [ProductController::class, 'destroy']);


// get,insert,update,delete stores
Route::get('/store_select', [StroesController::class, 'index']);
Route::get('/store_all', [StroesController::class, 'fetch']);

Route::post('/store', [StroesController::class, 'store']);
Route::post('/store_update', [StroesController::class, 'update']);
Route::post('/hasacount', [StroesController::class, 'hasAcount']);



//get,insert,update,delete bill
Route::post('/bill/select', [BillController::class, 'index']);
Route::post('/bill/{id}', [BillController::class, 'update']);
Route::post('/bill', [BillController::class, 'store']);
Route::delete('/bill/{bill_id}', [BillController::class, 'destroy']);

//get,insert,update,delete cart
Route::post('/store_get', [CartController::class, 'index']);
Route::post('/store_insert', [CartController::class, 'store']);
Route::post('/store/{store_id}/update', [CartController::class, 'update']);
Route::post('/store_delete', [CartController::class, 'destroy']);
Route::post('/store_delete_all', [CartController::class, 'removeProductsInCart']);



Route::prefix('/admin')->group(function () {
Route::post('/adduser', [AdminController::class, 'addUser']);
Route::post('/readuser', [AdminController::class, 'readUsers']);
Route::post('/updateuser', [AdminController::class, 'updateUser']);
Route::post('/deleteuser', [AdminController::class, 'deleteUser']);
Route::post('/deletestore', [AdminController::class, 'deleteStore']);
});


//admin panel
Route::prefix('/adminpanel')->group(function () {
    Route::post('/getallbills', [AdminController::class, 'getAllBills']);
    Route::post('/updatebills', [AdminController::class, 'updateBills']);
    Route::post('/deletebills', [AdminController::class, 'destroyBills']);
    Route::post('/getstores', [AdminController::class, 'getStores']);
    Route::post('/updatestore', [AdminController::class, 'updateStore']);
    Route::post('/addempoly', [AdminController::class, 'addUser']);
    Route::post('/registeremploy', [AdminController::class, 'registerUser']);
    Route::post('/getpayments', [AdminController::class, 'getPayments']);
    Route::post('/deleteadmin', [AdminController::class, 'deleteUser']);
    Route::post('/maininfromation', [AdminController::class, 'getMainInfo']);
    });
    
    Route::prefix('/advs')->group(function () {
        Route::get('/get/{country}', [AdvertisementController::class, 'index']);
        Route::post('/insert', [AdvertisementController::class, 'addAdvs']);
        Route::post('/update', [AdvertisementController::class, 'updateAdvs']);
        Route::post('/delete', [AdvertisementController::class, 'destroy']);
        Route::post('/sendnotifcation', [AdvertisementController::class, 'sendnotifcation']);
        
        });



        //application versions
        Route::post('/app_version', [AplicationVersionController::class, 'index']);
    
//get images in this route
Route::get('/images/{filename}', 
function($filename)
{
    $path = public_path('images/' . $filename);

        if (!file_exists($path)) {
            abort(404);
        }
        $file = file_get_contents($path);
        $type = mime_content_type($path);
        return response($file, 200)
            ->header('Content-Type', $type);
});





////////////////////////////
use Illuminate\Support\Facades\Storage;

use Illuminate\Support\Facades\Response;
Route::get('/download-apk', function () {
    $filePath = storage_path('app/public/app-release.apk'); // Replace 'file.apk' with the actual name of your APK file
    $fileName = 'app-release.apk'; // Replace 'file.apk' with the actual name of your APK file

    if (!Storage::disk('public')->exists('app-release.apk')) {
        abort(404, 'APK file not found.');
    }

    return Response::download($filePath, $fileName);
});


