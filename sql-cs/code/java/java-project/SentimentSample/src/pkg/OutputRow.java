package pkg;

//This object represents one output row
public class OutputRow {
    public final String id;
    public final String entry;
    public final String result; 

    public OutputRow(final String id, final String entry, final String result) {
        this.id = id;
        this.entry = entry;
        this.result = result;
    }

    @Override
    public String toString() { return id + ":" + entry + ":" + result; }
}
