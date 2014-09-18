Imports System.Xml

Class MainWindow
    Private Sub list_commands_SelectionChanged(sender As System.Object, e As System.Windows.Controls.SelectionChangedEventArgs) Handles list_commands.SelectionChanged
        Dim command As String
        command = list_commands.SelectedItem.InnerXML
        'MsgBox(command)

        'Dim doc As New XmlDocument()
        'doc.LoadXml("<command>" & command & "</command>")
        'Dim CommandsList As XmlNodeList = doc.SelectNodes("command")
        'Dim Comm As XmlNode
        'For Each Comm In CommandsList
        'Dim ChildList = Comm.ChildNodes()
        'For Each Child In ChildList
        'MsgBox(Child.ToString)
        'Next
        'Next

        Dim CmdDes As New CommandDescription
        CmdDes.Show()

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

