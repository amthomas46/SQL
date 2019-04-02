package pkg;

//This object represents one output row
public class OutputRow {
    public final String id;
    public final String entry;
    public final String origin; 
    public final String destination; 
    public final String datetime; 

    public OutputRow(final String id, final String entry, final String origin, final String destination, final String datetime) {
        this.id = id;
        this.entry = entry;
        this.origin = origin;
        this.destination = destination;
        this.datetime = datetime;
    }

    @Override
    public String toString() { return id + ": " + entry + ": " + origin + ": " + destination + ": " + datetime + "\n"; }
}
