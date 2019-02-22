package pkg;

//This object represents one output row
public class OutputRow {
    public final String id;
    public final String ngram;
    public final String result; 

    public OutputRow(final String id, final String ngram, final String result) {
        this.id = id;
        this.ngram = ngram;
        this.result = result;
    }

    @Override
    public String toString() { return id + ":" + ngram + ":" + result; }
}
