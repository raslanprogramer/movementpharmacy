<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Category;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;
use App\Traits\CheckAuthForAdmin;

class CategoryController extends Controller
{
    use CheckAuthForAdmin;

    public function index($country)
    {
        if (is_numeric($country)) {
            $categories = Category::where('country', $country)->get();
            return response()->json(['data' => $categories]);
        }
        return response()->json(['error' => 555]);
    }

    public function store(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            if ($result['rolls_name'] == 'admin' || $result['rolls_name'] == 'country_manager') {
                $validator = Validator::make($request->all(), [
                    'name' => 'required|string',
                    'img' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
                    'country' => 'required|integer',
                ]);

                if ($validator->fails()) {
                    //error 400 bad request
                    return response()->json(['message'=>$validator->errors()], 400);
                } else {
                    if ($result['rolls_name'] == 'country_manager' && $result['country'] != $request->country) {
                        return response()->json(['message' => 'ليس لديك صلاحية اضافة فئة خارج دولتك', 'error' => 5555], 401);
                    }
                    $category = new Category();
                    $category->name = $request->input('name');
                    $category->country = $request->input('country');
                    $image = $request->file('img');
                    $imageName = time() . '_' . $image->getClientOriginalName();
                    $image->move(public_path('images'), $imageName);
                    $category->img = $imageName;

                    $category->save();
                    return response()->json(['data' => $category], 201);
                }
                return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
            }
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
    }

    public function update(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            if ($result['rolls_name'] == 'admin' || $result['rolls_name'] == 'country_manager') {
                $validator = Validator::make($request->all(), [
                    'category_id' => 'required|integer',
                    'name' => 'required|string',
                    'img' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:6000',
                    'country' => 'required|integer',
                ]);

                if ($validator->fails()) {
                    return response()->json(['message'=>$validator->errors()], 400);
                }

                $category = Category::findOrFail($request->category_id);
                if (!$category) {
                    return response()->json(['message'=>"هذه الفئة غير موجودة"], 404);
                }
                if ($result['rolls_name'] == 'country_manager' && $result['country'] != $category->country) {
                    return response()->json(['message' => 'ليس لديك صلاحية تعديل فئة خارج دولتك', 'error' => 5555], 401);
                }
                $category->name = $request->input('name');
                $category->country = $request->input('country');

                if ($category->img && $request->hasFile('img')) {
                    $existingImagePath = public_path('images') . '/' . $category->img;
                    if (File::exists($existingImagePath)) {
                        // Remove the existing image from the public directory
                        File::delete($existingImagePath);
                    }
                }
                // Only update the 'img' field if it is not empty
                if ($request->hasFile('img')) {
                    $image = $request->file('img');
                    $imageName = time() . '_' . $image->getClientOriginalName();
                    $image->move(public_path('images'), $imageName);
                    $category->img = $imageName;
                }

                $category->save();

                return response()->json(['data'=>$category], 201);
            }
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
        return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
    }

    public function destroy(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            if ($result['rolls_name'] == 'admin' || $result['rolls_name'] == 'country_manager') {
                $validator = Validator::make($request->all(), [
                    'category_id' => 'required|integer',
                ]);
                if ($validator->fails()) {
                    return response()->json(['message'=>$validator->errors()], 400);
                }
                $category = Category::findOrFail($request->category_id);
                if (!$category) {
                    return response()->json(['message'=>'االفئة غير موجودة'], 404);
                }
                if ($result['rolls_name'] == 'country_manager' && $result['country'] != $category->country) {
                    return response()->json(['message' => 'ليس لديك صلاحية بحذف فئة خارج دولتك', 'error' => 5555], 401);
                }
                if ($category->img) {
                    $existingImagePath = public_path('images') . '/' . $category->img;
                    if (File::exists($existingImagePath)) {
                        // Remove the existing image from the public directory
                        File::delete($existingImagePath);
                    }
                }
                $category->delete();

                return response()->json('Category deleted successfully',201);
            }
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
        return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
    }
}
