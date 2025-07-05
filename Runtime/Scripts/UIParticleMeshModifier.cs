using UnityEngine;
using UnityEngine.UI;

namespace UIParticle
{
	[RequireComponent(typeof(RectTransform), typeof(Image))]
	[ExecuteAlways]
	public class UIParticleMeshModifier : MonoBehaviour, IMeshModifier
	{
		private static readonly int EmitterDimensions = Shader.PropertyToID("_EmitterDimensions");
		private static readonly int Position = Shader.PropertyToID("_Position");
		
		[SerializeField]
		private int quadsCount = 1;

		[SerializeField]
		private Vector2 quadSize = new(10, 10);

		[SerializeField]
		private float quadZDistance = 0.1f;

		private Graphic graphic;

		private Canvas canvas;
		private RectTransform rectTransform;
		
		private Vector2 LastEmitterDimensions;

		private bool GraphicObjectReady => graphic != null &&
										   graphic.materialForRendering.HasVector(EmitterDimensions);

		private void OnValidate()
		{
			canvas ??= GetComponentInParent<Canvas>(false);
			if (canvas == null)
			{
				Debug.LogError("UI Particle Mesh Modifier works only in canvas");
				return;
			}
			EnsureAdditionalChannels();
			rectTransform ??= GetComponent<RectTransform>();
			graphic = GetComponent<Graphic>();
			graphic.SetVerticesDirty();
		}

		private void Update()
		{
			if (graphic.materialForRendering == null)
				return;
			
			graphic.materialForRendering.SetVector(Position, transform.localPosition);
			
			if (!GraphicObjectReady) return;
			
			Vector2 size = graphic.materialForRendering.GetVector(EmitterDimensions);
			if (size == LastEmitterDimensions) return;

			LastEmitterDimensions = size;
			size = 2 * LastEmitterDimensions + quadSize;
			rectTransform.sizeDelta = size;
			
		}

		private void EnsureAdditionalChannels()
		{
			canvas.additionalShaderChannels |= AdditionalCanvasShaderChannels.Tangent;
		}

		public void ModifyMesh(Mesh mesh)
		{
			var halfSize = quadSize * 0.5f;
			var vertices = new Vector3[quadsCount * 4];
			var colors = new Color[vertices.Length];
			for (int i = 0; i < quadsCount; i++)
			{
				vertices[i * 4] = new Vector3(-halfSize.x, halfSize.y, i * quadZDistance);
				vertices[i * 4 + 1] = new Vector3(halfSize.x, halfSize.y, i * quadZDistance);
				vertices[i * 4 + 2] = new Vector3(-halfSize.x, -halfSize.y, i * quadZDistance);
				vertices[i * 4 + 3] = new Vector3(halfSize.x, -halfSize.y, i * quadZDistance);

				float vertexTint = i / (float)quadsCount;
				var color = new Color(vertexTint, vertexTint, vertexTint, 1);

				colors[4 * i + 0] = color;
				colors[4 * i + 1] = color;
				colors[4 * i + 2] = color;
				colors[4 * i + 3] = color;
			}

			mesh.vertices = vertices;
			mesh.colors = colors;
			mesh.uv = QuadHelper.GetMultipleQuadUVs(quadsCount);
			mesh.normals = QuadHelper.GetMultipleQuadNormals(quadsCount);
			mesh.triangles = QuadHelper.GetMultipleQuadTriangles(quadsCount);
		}

		public void ModifyMesh(VertexHelper verts)
		{
			// Verts could be original quad or already modified mesh. To be save, it's always cleared
			verts.Clear();
			
			Vector3 localPosition = transform.localPosition;
			var halfSize = quadSize * 0.5f;

			var quadVerts = new UIVertex[4];
			var vertices = new Vector3[4];
			var uvs = QuadHelper.GetQuadUVs();
			Color color = graphic.color;

			for (int i = 0; i < quadsCount; i++)
			{
				float vertexTint = i / (float)quadsCount;

				vertices[0] = new Vector3(-halfSize.x, -halfSize.y, i * quadZDistance);
				vertices[1] = new Vector3(-halfSize.x, halfSize.y, i * quadZDistance);
				vertices[2] = new Vector3(halfSize.x, halfSize.y, i * quadZDistance);
				vertices[3] = new Vector3(halfSize.x, -halfSize.y, i * quadZDistance);

				for (int j = 0; j < 4; j++)
				{
					quadVerts[j] = new UIVertex
					{
						position = vertices[j],
						color = color,
						uv0 = uvs[j],
						uv1 = uvs[j],
						uv2 = uvs[j],
						uv3 = uvs[j],
						normal = Vector3.zero,
						tangent = new Vector4(localPosition.x, localPosition.y, localPosition.z, vertexTint),
					};
				}

				verts.AddUIVertexQuad(quadVerts);
			}
		}
	}
}