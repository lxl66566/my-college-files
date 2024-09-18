from pathlib import Path

import cv2
from PIL import Image


def ipt(img: Path, mask: Path, output: Path):
    # inpaint = Inpaint(str(img), str(mask))
    # inpainted_img = inpaint()
    # save_numpy_img(inpainted_img, output)
    # run(f"""pyinpaint --org_img "{img}" --mask "{mask}" """, shell=True)
    # run(f"""cp {img} {output} """, shell=True)
    original_image = cv2.imread(str(img))
    mask = cv2.imread(str(mask), 0)  # 掩码是灰度图

    # 使用inpaint方法修复划痕
    restored_image = cv2.inpaint(original_image, mask, 3, cv2.INPAINT_TELEA)

    # 保存修复后的图像
    cv2.imwrite(str(output), restored_image)


def save_numpy_img(img, output):
    # Assuming inpainted_img is your NumPy array
    # Convert to uint8 if necessary
    # inpainted_img = np.clip(img, 0, 255).astype(np.uint8)

    # Convert NumPy array to image
    image = Image.fromarray(img)

    # Save to file
    image.save(str(output))
