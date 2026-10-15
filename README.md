# Synthetic hands generator

Generates synthetic **depth images of human hand postures** from a 27-DOF
kinematic hand model. Runs in MATLAB and GNU Octave with no toolboxes required.

![Contact sheet of synthetic depth hands](docs/img/contact_sheet.png)

This is the generator behind the synthetic part of the hand gesture corpus in
the PhD thesis *Contributions to Hand Gesture Recognition on the basis of
Range Data* (Javier Molina Vela, Universidad Autónoma de Madrid, 2012),
Sections 2.2 and 3.2. The thesis used it to train gesture classifiers on
synthetic data alone and then evaluate them on recordings of real people.

> **Status:** research code from 2009–2013, published for reference.
> Comments and many identifiers are in Spanish. It is not actively
> developed.

## How it works

1. **Pose:** `generateHandParameters` gives the 27 joint angles and the
   global position of a posture, picked by its dictionary id.
2. **Hand profile:** `generateUserProfiles` sets the anatomy: scale, the
   fingers/palm aspect ratio (FP-AR) and the palm width (PW). Varying these
   gives different "synthetic users".
3. **Skeleton:** `calculatePoints` applies forward kinematics to get the 3D
   joint and fill points.
4. **Volume:** `encarna` ("give it flesh") puts the skeleton in a
   144×176×256 voxel grid and dilates it with a Euclidean ball.
5. **Depth image:** `model2depthImage` keeps the nearest surface along the
   view axis. The result is a QCIF uint8 image similar to a time-of-flight
   capture.

## Quick start

```matlab
setup_paths
d = renderDepthHand(5);                          % open hand, default profile
imshow(d, [])

d = renderDepthHand(8, 'Rotation', [pi/8 0 0], ... % fist, tilted
                       'Scale', 4, 'FingerPalmRatio', 1.2);

hands_demo                                       % writes output/*.png
```

## Posture ids

| Ids | Postures |
|---|---|
| 1–8 | One, Two, Three, Four, Five, Ok, Stop, Fist |
| 11, 12 | Additional postures (unnamed in the source) |
| 101–104 | Miscellaneous pose-based dictionary |
| 201–205 | Dictionary of Soutschek et al. (2008): 202 is "Jedi" and 205 is "Ok, palm right" |
| 301–312 | 12-pose dictionary (Kollorz et al., 2008) |
| 401–427 | Spanish Sign Language alphabet, static letters a–z |

Some ids share a definition. For example, 2, 203, 422 and 423 are the same
pose. The full list is in `src/generateHandParameters.m`.

## Repository layout

```
src/                  generator functions
  renderDepthHand.m   one-call English entry point (new)
  dilateBall.m        ball dilation (new, replaces a proprietary toolbox)
scripts/
  datasets/           the original batch scripts that built the thesis datasets
  demos/              the original interactive demos (main1–main4)
tests/smoke_test.m    renders every posture and checks a reference image
hands_demo.m          renders the contact sheet above
```

The dataset scripts write PNG files named `<user-or-profile>_<postureId>_<iteration>[_<n>].png`
into `syn_AllPostures_<ID>/`, together with `dict.txt`, `parameters.txt`,
`semanticIds.txt` and `scale.txt`. They differ in how many random points of
view they use and in which profile parameters they vary:

| Script | Variation |
|---|---|
| `A` | One frontal view per posture |
| `B` | 10 random scales in [2.5, 7.5] |
| `C`, `G` | 10 scales × 50 views. The view ranges are Δθx ∈ [0, π/8], Δθy, Δθz ∈ [−π/8, π/8] |
| `D`, `E`, `F` | 200, 500 or 1000 views at scale 5 |
| `H2` | Fingers/palm ratio in {0.75, 1, 1.25} |
| `I2*`, `J2*` | Grids of user profiles (FP-AR × PW): `I2*` with 1 view, `J2*` with 20 views. `I2e`/`J2e` match set B in Table 3.1 of the thesis |

`generateVideosAndAnnotations.m` turns a folder of frames into one AVI per
posture and user.

## Changes from the original code

- **Toolbox-free dilation.** The volume used to be dilated with the
  proprietary SDC Morphology Toolbox (`mmdil`/`mmsedisk`). It is replaced by
  `dilateBall`. Checked against images generated in 2013, the silhouettes
  agree to within about 2–3% of the pixels. The rest of the difference comes
  from changes to the model made after those images were rendered.
- **Fixed calls.**
  - `rands(seed)` never seeded anything; it is now `rng(seed)`, so dataset
    runs are reproducible.
  - `wgn` (Communications Toolbox) is replaced by plain Gaussian noise of the
    same power.
  - `avifile` was removed from MATLAB and is replaced by `VideoWriter`.
  - The default call to `generateUserProfiles` in `calculatePoints` had the
    wrong number of arguments.
- **Paths.** Hard-coded absolute paths are gone, and sources are converted to
  UTF-8 with LF line endings.

## Known limitations

- The `grosor` (thickness) profile parameter is stored but never used. The
  dilation radius is always `0.8 × scale`.
- `I2_…` and `I2d_…` write to output folders whose names don't match their
  file names (`I2d` and `I2e`). This is kept as in the original.
- The depth image is a plain orthographic projection. It does not simulate
  sensor noise.

## Citation

If you use this code, please cite the thesis:

```bibtex
@phdthesis{molina2012thesis,
  author = {Molina Vela, Javier},
  title  = {Contributions to Hand Gesture Recognition on the basis of Range Data},
  school = {Universidad Aut\'onoma de Madrid},
  year   = {2012}
}
```

The synthetic training framework is described in J. Molina and
J. M. Martínez, *A synthetic training framework for providing gesture
scalability to 2.5D pose-based hand gesture recognition systems*, Machine
Vision and Applications, 2014.

## License

MIT. See [LICENSE](LICENSE).
