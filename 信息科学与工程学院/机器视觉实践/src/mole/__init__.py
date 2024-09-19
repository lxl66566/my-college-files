from ..utils import use_image
from .inpaint import remove_mole_inpaint
from .move_region import remove_mole_move_region


def remove_mole(mode: int):
    match mode:
        case 0:
            use_image(
                remove_mole_inpaint,
                "face.jpg",
            )
        case 1:
            use_image(
                remove_mole_move_region,
                "face.jpg",
            )
        case _:
            raise ValueError(f"Invalid mode: {mode}")
