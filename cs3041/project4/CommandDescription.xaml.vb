Imports System.Xml

Partial Public Class CommandDescription
    ' Private Sub Window_Loaded(ByVal sender As System.Object, ByVal e As System.Windows.RoutedEventArgs)
    'CommandsLoad()
    ' End Sub

    'Private Sub CommandsLoad()
    ' Set the commands.xml file to Build Action="Content" and 
    ' Copy to Output Directory="Copy Always" in Properties window 
    'Dim xElem = XElement.Load("commands.xml")

    ' Get All Products 
    'Dim commandsList = From cmd In xElem.Descendants("Command") _
    ' Order By cmd.Element("dname").Value _
    ' Select cmd.Element("Name").Value

    'FirstCommands.DataContext = commandsList
    'End Sub

    Private Sub Window_Loaded()
        Dim reader As XmlTextReader = New XmlTextReader("commands.xml")
        Dim ElementName As String = ""
        Do While (reader.Read())
            Select Case reader.NodeType
                Case XmlNodeType.Element
                    ElementName = reader.Name
                    'Console.Write(reader.Name + ":")
                    'If reader.HasAttributes Then
                    ' Console.Write(":")
                    '  While reader.MoveToNextAttribute()
                    '        Console.Write("{0} = '{1}'", reader.Name, reader.Value)
                    '   End While
                    'End If
                Case XmlNodeType.Text
                    Console.WriteLine()
                    Console.WriteLine("{0}: {1}", ElementName, reader.Value)
                    'Case XmlNodeType.EndElement
                    '  Console.WriteLine(reader.Name)
            End Select
        Loop
        Console.ReadLine()
    End Sub

    Private Sub btn_launchSearch_Click(sender As System.Object, e As System.Windows.RoutedEventArgs) Handles btn_launchSearch.Click
        Dim searchQuery = txt_searchInput.Text
        If searchQuery = "" Then
            MsgBox("Please enter a command name to search for!")
        Else
            MsgBox("You searched for " & searchQuery & ". No results were found! Please select a command from the list of frequently used commands.")
        End If
    End Sub
End Class
