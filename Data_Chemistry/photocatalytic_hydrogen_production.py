import torch
import pickle
from torch import Tensor
from pathlib import Path
from ...base import JSONExperiment
from web.apps.libs.config import TKWARGS


class PhotocatalyticHydrogenProduction(JSONExperiment):
    """Photocatalytic Hydrogen Production experiment."""

    def __init__(self):
        experiment_card_path = Path(__file__).parent / "experiment_card.json"
        super().__init__(experiment_card_path=experiment_card_path)

        self._load_gp()

    def _load_gp(self):
        """Load the GP model from the file."""
        model_path = Path(__file__).parent / "model" / "her_model.pkl"
        self.gp = pickle.loads(model_path.read_bytes())

    def objective(self, x: Tensor) -> Tensor:
        x = torch.atleast_2d(x).to(
            dtype=TKWARGS["dtype"],
            device="cpu",
        )  # CPU as the model is trained on CPU
        out = self.gp.predict(x)
        # If a value is negative set it to 0 as it is not possible
        out[out < 0] = 0
        out = torch.tensor(out).to(**TKWARGS)
        return out
