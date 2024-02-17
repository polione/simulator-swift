from scipy.spatial import distance

def mydistance(df1, df2):
    ds = []

    for col in df1.columns:
        try:
            p = df1[col].value_counts(normalize=True).sort_index()
            q = df2[col].value_counts(normalize=True).reindex(p.index, fill_value=0.0).sort_index()
            ds.append(distance.jensenshannon(p, q))
        except Exception as e:
            print(e)
            ds.append(1.0)

    return sum(ds) / len(ds)
