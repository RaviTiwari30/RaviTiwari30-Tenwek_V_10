<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FileRegistered.aspx.cs" Inherits="Design_MRD_FileRegistered" Async="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/ScrollableGrid.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<link href="../../Styles/grid24.css" rel="stylesheet" />
<link href="../../Styles/CustomStyle.css" rel="stylesheet" />
<link href="../../Styles/framestyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>
<link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
<script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
<script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
<script type="text/javascript" src="../../Scripts/shortcut.js"></script>
<script type="text/javascript">

    $(function () {
        //$('#<%=grdDocsg.ClientID %>').Scrollable();
        var checkBoxSelector1 = '#<%=grdDocsg.ClientID%> input[id*="rdbstatus1"]:radio';
        var checkBoxSelector2 = '#<%=grdDocsg.ClientID%> input[id*="rdbstatus2"]:radio';
        var checkBoxSelector3 = '#<%=grdDocsg.ClientID%> input[id*="rdbstatus3"]:radio';
        var checkBoxSelector4 = '#<%=grdDocsg.ClientID%> input[id*="rdbstatus4"]:radio';

        $('[id$=rdbselectAll1]').click(function () {
            $('[id$=rdbselectAll2]').attr('checked', false);
            $('[id$=rdbselectAll3]').attr('checked', false);
            $('[id$=rdbselectAll4]').attr('checked', false);
            if ($(this).is(":checked")) {
                $(checkBoxSelector1).attr('checked', true);
            }
            else {
                $(checkBoxSelector1).attr('checked', false);
            }
        }
                                           );
        $('[id$=rdbselectAll2]').click(function () {

            $('[id$=rdbselectAll1]').attr('checked', false);
            $('[id$=rdbselectAll3]').attr('checked', false);
            $('[id$=rdbselectAll4]').attr('checked', false);
            if ($(this).is(":checked")) {
                $(checkBoxSelector2).attr('checked', true);
            }
            else {
                $(checkBoxSelector2).attr('checked', false);
            }
        }
           );

        $('[id$=rdbselectAll3]').click(function () {

            $('[id$=rdbselectAll1]').attr('checked', false);
            $('[id$=rdbselectAll2]').attr('checked', false);
            $('[id$=rdbselectAll4]').attr('checked', false);
            if ($(this).is(":checked")) {
                $(checkBoxSelector3).attr('checked', true);
            }
            else {
                $(checkBoxSelector3).attr('checked', false);
            }
        }
           );


        $('[id$=rdbselectAll4]').click(function () {

            $('[id$=rdbselectAll1]').attr('checked', false);
            $('[id$=rdbselectAll2]').attr('checked', false);
            $('[id$=rdbselectAll3]').attr('checked', false);
            if ($(this).is(":checked")) {
                $(checkBoxSelector4).attr('checked', true);
            }
            else {
                $(checkBoxSelector4).attr('checked', false);
            }
        }
                    );
    });

    $(document).ready(function () {
        var MaxLength = 100;
        $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
            event.preventDefault();
        });
        $('#<%=txtRemarks.ClientID%>').bind("keypress", function (e) {
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            if (e.keyCode == 39 || keychar == "'") {
                return false;
            }

            if ($(this).val().length >= MaxLength) {

                if (window.event)//IE
                {
                    e.returnValue = false;
                    return false;
                }
                else//Firefox
                {
                    e.preventDefault();
                    return false;
                }

            }
        });
    });

    //    function room() {
    //        $("#<%=cmbAlmirah.ClientID %> option").remove();
    //        if ($("#<%=cmbRoom.ClientID %>").val() > 0) {
    //            $.ajax({
    //                url: "../Common/CommonService.asmx/room",
    //                data: '{ Room: "' + $("#<%=cmbRoom.ClientID %>").val() + '"}', // parameter map
    //                type: "POST", // data has to be Posted    	        
    //                contentType: "application/json; charset=utf-8",
    //                timeout: 120000,
    //                dataType: "json",
    //                success: function (result) {
    //                    Almirah = jQuery.parseJSON(result.d);
    //                    $("#<%=cmbAlmirah.ClientID %>").append($("<option></option>").val("0").html("Select"));

    //                    for (i = 0; i < Almirah.length; i++) {
    //                        $("#<%=cmbAlmirah.ClientID %>").append($("<option></option>").val(Almirah[i].AlmID).html(Almirah[i].Name));

    //                    }
    //                    $("#<%=cmbAlmirah.ClientID %>").attr("disabled", false);


    //                },
    //                error: function (xhr, status) {
    //                    alert("Error ");
    //                    $("#<%=cmbAlmirah.ClientID %>").attr("disabled", false);
    //                    window.status = status + "\r\n" + xhr.responseText;
    //                }
    //            });
    //        }
    //    }
    //    function almirah() {
    //        //alert($("#<%=cmbAlmirah.ClientID %>").val());
    //        $("#<%=cmbShelf.ClientID %> option").remove();
    //        if ($("#<%=cmbAlmirah.ClientID %>").val() > 0) {
    //            $.ajax({
    //                url: "../Common/CommonService.asmx/almirah",
    //                data: '{ Almirah: "' + $("#<%=cmbAlmirah.ClientID %>").val() + '"}', // parameter map
    //                type: "POST", // data has to be Posted    	        
    //                contentType: "application/json; charset=utf-8",
    //                timeout: 120000,
    //                dataType: "json",
    //                success: function (result) {
    //                    Shelf = jQuery.parseJSON(result.d);
    //                    //alert(Shelf);
    //                    $("#<%=cmbShelf.ClientID %>").append($("<option></option>").val("0").html("Select"));

    //                    for (i = 0; i < Shelf.length; i++) {
    //                        $("#<%=cmbShelf.ClientID %>").append($("<option></option>").val(Shelf[i].ID).html(Shelf[i].ShelfNo));
    //                    }
    //                    $("#<%=cmbShelf.ClientID %>").attr("disabled", false);
    //                },
    //                error: function (xhr, status) {
    //                    alert("Error ");
    //                    $("#<%=cmbShelf.ClientID %>").attr("disabled", false);
    //                    window.status = status + "\r\n" + xhr.responseText;
    //                }
    //            });
    //        }

    //    }
    function checkForSecondDecimal(sender, e) {
        formatBox = document.getElementById(sender.id);
        strLen = sender.value.length;
        strVal = sender.value;
        hasDec = false;
        e = (e) ? e : (window.event) ? event : null;


        if (e) {
            var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


            if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                for (var i = 0; i < strLen; i++) {
                    hasDec = (strVal.charAt(i) == '.');
                    if (hasDec)
                        return false;
                }
            }
        }
        return true;
    }
    $(document).ready(function () {
        $(".GridViewStyle tr").each(function () {
            $(this).closest("tr").find("input[id*=txtQty]").bind("blur keyup keydown", function () {
                if ($(this).closest("tr").find("input[id*=txtQty]").val().charAt(0) == ".") {
                    $(this).closest("tr").find("input[id*=txtQty]").val('');
                }
                if ($(this).closest("tr").find("input[id*=txtQty]").val().charAt(0) == "0") {
                    $(this).closest("tr").find("input[id*=txtQty]").val('');
                }
            });
        });
    });
    function ValidateDots() {
        if ($("#<%=txtAdditional.ClientID %>").val().charAt(0) == ".") {
            $("#<%=txtAdditional.ClientID %>").val('');
            return false;
        }
        if ($("#<%=txtSequence.ClientID %>").val().charAt(0) == ".") {
            $("#<%=txtSequence.ClientID %>").val('');
            return false;
        }
    }
    function pageLoad(sender, args) {
        if (!args.get_isPartialLoad()) {
            $addHandler(document, "keydown", onKeyDown);
        }
    }
    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            if ($find("mpopRack")) {
                $("#<%=txtAlmirah.ClientID %>").val('');
                $("#<%=cmbRoomPopUp.ClientID %>").prop("selectedIndex", 0);
                $("#<%=txtNoOfShelf.ClientID %>").val('');
                $("#<%=txtMaxNoRecord.ClientID %>").val('');
                $find("mpopRack").hide();
            }
            if ($find("mpe1")) {
                $find("mpe1").hide();
            }
            if ($find("mpe2")) {
                $("#<%=lblDocument.ClientID %>").text('');
                $("#<%=chkEdit.ClientID %>").attr('Checked', false);
                if ($("#<%=ddlDocument.ClientID %>").is(':visible')) {
                    $("#<%=ddlDocument.ClientID %>").prop("selectedIndex", 0);
                    $("#<%=ddlDocument.ClientID %>").hide();
                }
                $("#<%=txtDocument.ClientID %>").val('').show();
                $("#<%=txtSequence.ClientID %>").val('');
                //  $('#<%=ddlActive.ClientID %>').filter('[value="1"]').attr('checked', true);
                $('#<%=ddlActive.ClientID %>').val('1').attr('checked', true);
                $find("mpe2").hide();
            }


        }
    }
    function ClearRack() {
        $("#<%=txtAlmirah.ClientID %>").val('');
        $("#<%=cmbRoomPopUp.ClientID %>").prop("selectedIndex", 0);
        $("#<%=txtNoOfShelf.ClientID %>").val('');
        $("#<%=txtMaxNoRecord.ClientID %>").val('');
    }
    function validateRack() {
        if (typeof (Page_Validators) == "undefined") return;
        var Almirah = document.getElementById("<%=reqAlmirah.ClientID%>");
        var Room = document.getElementById("<%=reqRoom.ClientID%>");
        var Shelf = document.getElementById("<%=reqShelf.ClientID%>");
        var File = document.getElementById("<%=reqFile.ClientID%>");
        var LblName = document.getElementById("<%=lblMSGAlmirah.ClientID%>");
        ValidatorValidate(Almirah);
        if (!Almirah.isvalid) {
            LblName.innerText = Almirah.errormessage;
            return false;
        }

        ValidatorValidate(Room);
        if (!Room.isvalid) {
            LblName.innerText = Room.errormessage;
            return false;
        }
        ValidatorValidate(Shelf);
        if (!Shelf.isvalid) {
            LblName.innerText = Shelf.errormessage;
            return false;
        }
        ValidatorValidate(File);
        if (!File.isvalid) {
            LblName.innerText = File.errormessage;
            return false;
        }

    }
    function validateRoom() {
        if ($("#<%=btnRoom.ClientID %>").val() == "Save") {
            if ($("#<%=txtRoom.ClientID %>").val() == "") {
                $("#<%=lblMSGRoom.ClientID %>").text('Please Enter Room Name');
                $("#<%=txtRoom.ClientID %>").focus();
                return false;
            }


        }
    }


</script>
<script type="text/javascript">
    $(document).ready(function () {
        //  Sys.WebForms.PageRequestManager.getInstance().add_endRequest(validateDoc);
    });

    function validateDoc() {
        if ($("#<%=chkEdit.ClientID %>").is(':checked')) {
            if ($("#<%=ddlDocument.ClientID %> option:selected").text() == "Select") {
                $("#<%=lblDocument.ClientID %>").text('Please Select Document Name');
                return false;
            }
            if ($("#<%=txtDocument.ClientID %>").val() == "" || $("#<%=txtDocument.ClientID %>").val().length == 0) {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Document Name');
                $("#<%=txtDocument.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == "") {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == 0) {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Valid Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }

        }
        else {
            if ($("#<%=txtDocument.ClientID %>").is(':visible') && $("#<%=txtDocument.ClientID %>").val() == "") {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Document Name');
                $("#<%=txtDocument.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == "") {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtSequence.ClientID %>").val() == 0) {
                $("#<%=lblDocument.ClientID %>").text('Please Enter Valid Sequence No.');
                $("#<%=txtSequence.ClientID %>").focus();
                return false;
            }
        }
    }
    function check(e) {
        var keynum
        var keychar
        var numcheck
        // For Internet Explorer  
        if (window.event) {
            keynum = e.keyCode
        }
            // For Netscape/Firefox/Opera  
        else if (e.which) {
            keynum = e.which
        }
        keychar = String.fromCharCode(keynum)
        //List of special characters you want to restrict
        if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
            return false;
        }

        else {
            return true;
        }
    }
    function validatespaceDoc() {
        var Document = $('#<%=txtDocument.ClientID %>').val();
        if (Document.charAt(0) == ' ' || Document.charAt(0) == '.' || Document.charAt(0) == ',' || Document.charAt(0) == '0') {
            $('#<%=txtDocument.ClientID %>').val('');
            $("#<%=lblDocument.ClientID %>").text('First Character Cannot Be Space/Dot');
            Document.replace(Document.charAt(0), "");
            return false;
        }

    }
    function validatespaceRack() {
        var Rack = $('#<%=txtAlmirah.ClientID %>').val();
        if (Rack.charAt(0) == ' ' || Rack.charAt(0) == '.' || Rack.charAt(0) == ',' || Rack.charAt(0) == '0') {
            $('#<%=txtAlmirah.ClientID %>').val('');
            $("#<%=lblMSGAlmirah.ClientID %>").text('First Character Cannot Be Space/Dot');
            Rack.replace(Rack.charAt(0), "");
            return false;
        }
    }
    function validatespaceRoom() {
        var Room = $('#<%=txtRoom.ClientID %>').val();
        if (Room.charAt(0) == ' ' || Room.charAt(0) == '.' || Room.charAt(0) == ',' || Room.charAt(0) == '0') {
            $('#<%=txtRoom.ClientID %>').val('');
            $("#<%=lblMSGRoom.ClientID %>").text('First Character Cannot Be Space/Dot');
            Room.replace(Room.charAt(0), "");
            return false;
        }

    }
    function validateFile() {
        if (typeof (Page_Validators) == "undefined") return;
        var Room = document.getElementById("<%=reqFileRoom.ClientID%>");
        var Rack = document.getElementById("<%=reqRack.ClientID%>");
        var LblName = document.getElementById("<%=lblmainmsg.ClientID%>");
        //ValidatorValidate(Room);
        //if (!Room.isvalid) {
        //    LblName.innerText = Room.errormessage;
        //    return false;
        //}

        //ValidatorValidate(Rack);
        //if (!Rack.isvalid) {
        //    LblName.innerText = Rack.errormessage;
        //    return false;
        //}
        if (Page_IsValid) {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }       
        else {
            document.getElementById('<%=btnSave.ClientID%>').disabled = false;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
        }

    }

    $CreateDocument = function (e) {
        e.preventDefault();
        $('#divCreateDocument').showModel();
    }
    $(document).ready(function () {
        $("table[id*=grdDocsg] input[id*=txtQty]").bind('keyup keydown', function (e) {
            if ($(this).closest("tr").find("input[id*=txtQty]").val() == "") {
                $(this).closest("tr").find("input[id*=txtQty]").val('0');
            }
            var keycode = e.keyCode ? e.keyCode : e.which;
            var keynum
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            var keychar = String.fromCharCode(keynum)
            if ($(this).closest("tr").find("input[id*=txtQty]").val().charAt(0) == "0") {
                if (keycode >= "49" && keycode <= "57") {
                    $(this).closest("tr").find("input[id*=txtQty]").val(keychar);
                    return false;
                }
            }


        });
    });

    $(document).ready(function () {
        var exitSubmit = false;
        $("#<%=grdDocsg.ClientID %> tr").each(function (e) {
            //            var textBox = $(this).find("input[type='text']");
            //            if (textBox.val().length === 0) {
            //                $("#<%=lblMSGAlmirah.ClientID %>").text('Please Enter Room Name');
            //                exitSubmit = true;
            //                return false;
            //            }
            //            else {
            //                $("#<%=lblMSGAlmirah.ClientID %>").text('Please Enter Room Name');
            //                exitSubmit = true;
            //                return true;
            //            }
        });
    });
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <style type="text/css">
        .style1 {
            width: 3px;
        }

        .style2 {
            width: 215px;
        }

        .auto-style1 {
            width: 142px;
        }

        .auto-style2 {
            width: 145px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="margin-top: 0px;">
            <Ajax:ScriptManager ID="scripmanager1" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>File Register</b><br />
                <asp:Label ID="lblmainmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div style="overflow: auto; padding: 3px; height: 310px;">
                    <table style="width: 100%; border-collapse: collapse" border="0">
                        <tr>
                            <td>
                                <asp:GridView ID="grdDocsg" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Seq. No.">
                                            <ItemTemplate>
                                                <%#Eval("SequenceNo") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDocID" Text='<%#Eval("DocumentID") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblName" Text='<%#Eval("Name") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qty.">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtQty" runat="server" Width="50px"
                                                    Text='<%#Eval("Doc_Qty") %>' MaxLength="3" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="fEarn" runat="server" TargetControlID="txtQty" ValidChars="."
                                                    FilterMode="ValidChars" FilterType="Numbers, Custom">
                                                </cc1:FilteredTextBoxExtender>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Received and Completed">
                                            <HeaderTemplate>
                                                <%--<asp:RadioButton ID="rdbselectAll1" runat="server"  GroupName="rdbStatusAll" Text="Received and Completed" style="float:right; padding-right:5px;" />
                                                --%>
                                                <asp:CheckBox ID="rdbselectAll1" runat="server" Text="Received and Completed" Style="float: right; padding-right: 5px;" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:RadioButton GroupName="rdbStatus" ID="rdbstatus1" Checked='<%#Util.GetBoolean(Eval("A")) %>'
                                                    runat="server"></asp:RadioButton>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Received and InComplete">
                                            <HeaderTemplate>
                                                <%--<asp:RadioButton ID="rdbselectAll2" runat="server" GroupName="rdbStatusAll" Text="Received and InComplete" style="float:right; padding-right:5px;" />--%>
                                                <asp:CheckBox ID="rdbselectAll2" runat="server" Text="Received and InComplete" Style="float: right; padding-right: 5px;" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:RadioButton ID="rdbstatus2" GroupName="rdbStatus" Checked='<%#Util.GetBoolean(Eval("B")) %>'
                                                    runat="server"></asp:RadioButton>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Document Not Received">
                                            <HeaderTemplate>
                                                <%--  <asp:RadioButton ID="rdbselectAll3" runat="server" GroupName="rdbStatusAll" Text="Document Not Received" style="float:right; padding-right:5px;" />--%>
                                                <asp:CheckBox ID="rdbselectAll3" runat="server" Text="Document Not Received" Style="float: right; padding-right: 5px;" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:RadioButton ID="rdbstatus3" GroupName="rdbStatus" Checked='<%#Util.GetBoolean(Eval("C")) %>'
                                                    runat="server"></asp:RadioButton>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Document Not Required">
                                            <HeaderTemplate>
                                                <%-- <asp:RadioButton ID="rdbselectAll4" runat="server"   GroupName="rdbStatusAll" Text="Document Not Required" style="float:right; padding-right:5px;" />--%>
                                                <asp:CheckBox ID="rdbselectAll4" runat="server" Text="Document Not Required" Style="float: right; padding-right: 5px;" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:RadioButton ID="rdbstatus4" GroupName="rdbStatus" Checked='<%#Util.GetBoolean(Eval("D")) %>'
                                                    runat="server"></asp:RadioButton>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="FileDetID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFileDetID" Text='<%#Eval("FileDetID") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="display:none">
                <div class="Purchaseheader">
                    Location
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Room
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:UpdatePanel ID="UpdtpnlRoom" runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList ID="cmbRoom" ToolTip="Select Room" runat="server" CssClass="requiredField" Width=""
                                        OnSelectedIndexChanged="cmbRoom_SelectedIndexChanged" AutoPostBack="true" TabIndex="1">
                                    </asp:DropDownList>
                                    <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqFileRoom" SetFocusOnError="true" runat="server" ControlToValidate="cmbRoom"
                                        ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Room" Display="None"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="cmbRoom" EventName="SelectedIndexChanged" />
                                </Triggers>
                            </asp:UpdatePanel>
                            </div>
                            <div class="col-md-3"></div>
                            <div class="col-md-4">
                                <asp:Button ID="btnDoc" runat="server" ToolTip="Click to Create New Document" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="$CreateDocument(event)"
                                Text="Create New Document" />
                            </div>
                            <div class="col-md-4">
                                <asp:Button ID="btnCreateRoom" Text="Create New Room" CssClass="ItDoseButton"
                            runat="server" OnClick="btnCreateRoom_Click" ToolTip="Click to Create New Room" />
                            </div>
                            <div class="col-md-4">
                            <asp:Button ID="btnCreateRack" Text="Create New Rack" CssClass="ItDoseButton"
                            runat="server" OnClick="btnCreateRack_Click" ToolTip="Click to Create New Rack" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Rack
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:UpdatePanel ID="UpdtpnlAlmirah" runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList CssClass="requiredField" ID="cmbAlmirah" runat="server" Width="" OnSelectedIndexChanged="cmbAlmirah_SelectedIndexChanged"
                                        AutoPostBack="true" ToolTip="Select Rack" TabIndex="2">
                                    </asp:DropDownList>
                                    <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqRack" SetFocusOnError="true" runat="server" ControlToValidate="cmbAlmirah"
                                        ValidationGroup="SaveFile" InitialValue="Select" ErrorMessage="Please Select Rack" Display="None"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="cmbAlmirah" EventName="SelectedIndexChanged" />
                                </Triggers>
                            </asp:UpdatePanel>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Shelf
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:UpdatePanel ID="UpdtpnlShelf" runat="server">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="cmbShelf" CssClass="requiredField" runat="server" TabIndex="3" Width="" AutoPostBack="true"
                                                    OnSelectedIndexChanged="cmbShelf_SelectedIndexChanged" ToolTip="Select Shelf">
                                                </asp:DropDownList>

                                                <asp:Label ID="Label9" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="cmbShelf"
                                                    ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Shelf" Display="None"></asp:RequiredFieldValidator>

                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="cmbShelf" EventName="SelectedIndexChanged" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Remarks
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                                 <asp:TextBox ID="txtRemarks" TabIndex="4" ToolTip="Enter Remarks" runat="server"
                                Width="368px" TextMode="MultiLine" Height="60px"></asp:TextBox>
                            </div>
                           
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table>
                    <tr>
                        <td style="display: none;">
                            <asp:Label ID="lblFileId" runat="server" Visible="False" Text="Old FileNo. "></asp:Label><asp:Label
                                ID="lblCounter" runat="server" Font-Bold="True"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">
                            <%--For Additional Space in Shelf :&nbsp;--%>
                        </td>
                        <td>
                            <asp:TextBox ID="txtAdditional" runat="server" Width="147px" Style="display: none;"
                                MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDots()"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fteAdditional" runat="server" TargetControlID="txtAdditional"
                                ValidChars="." FilterMode="ValidChars" FilterType="Numbers, Custom">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="lblcur" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblroomid" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblrackid" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblshelno" runat="server" Visible="false"></asp:Label>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlFileNo" runat="server" Visible="False" Width="140px">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:Label ID="lblFileNo" runat="server" Font-Bold="True" Visible="False"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" CssClass="ItDoseButton" CausesValidation="false"
                    ValidationGroup="SaveFile" TabIndex="5" ToolTip="Click to Save" OnClientClick="return validateFile();"></asp:Button>
            </div>
        </div>
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            ScrollBars="Vertical" Height="255px" Width="530px">
            <div class="POuter_Box_Inventory" style="width: 510px;">
                <div class="Purchaseheader" style="width: 500px;">
                    Room Master &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  
                &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;<em><span style="font-size: 7.5pt">Press esc to 
                close</span></em>
                </div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table style="width: 490px; height: 60px; margin-right: 0px;">
                            <tr style="text-align: center">
                                <td colspan="4">
                                    <asp:Label ID="lblMSGRoom" runat="server" CssClass="ItDoseLblError" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 200px"></td>
                                <td colspan="2" style="text-align: center">
                                    <%-- <asp:RadioButtonList ID="rbtnRoom" runat="server" RepeatDirection="Horizontal" AutoPostBack="True"
                                    OnSelectedIndexChanged="rbtnRoom_SelectedIndexChanged">
                                    <asp:ListItem  Value="0">Add New</asp:ListItem>
                                    <asp:ListItem Value="1" Selected="True">Edit</asp:ListItem>
                                </asp:RadioButtonList>--%>
                                </td>
                                <td style="width: 200px"></td>
                            </tr>
                            <tr>
                                <td style="width: 200px"></td>
                                <td></td>
                                <td class="style2"></td>
                                <td style="width: 200px"></td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: right">Room Name :&nbsp;
                                </td>
                                <td style="text-align: left;" class="style2">
                                    <asp:TextBox ID="txtRoom" runat="server" Width="200px" ToolTip="Enter Room Name" TabIndex="1" MaxLength="50"
                                        onkeyup="validatespaceRoom();"></asp:TextBox>
                                </td>
                                <td style="width: 200px; text-align: left;">
                                    <asp:Button ID="btnRoom" Text="Save" CssClass="ItDoseButton" runat="server" OnClick="btnRoom_Click"
                                        ValidationGroup="doc" OnClientClick="return validateRoom();" TabIndex="2" ToolTip="Click to Save" />
                                    <asp:Button ID="btnCancel" runat="server" TabIndex="3" Text="Close" CssClass="ItDoseButton" OnClick="btnCancel_Click" ToolTip="Click to Close" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 200px"></td>
                                <td></td>
                                <td class="style2"></td>
                                <td style="width: 200px"></td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center">
                                    <asp:GridView ID="grdRoom" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                        Font-Names="Verdana" Font-Size="10pt" OnRowCancelingEdit="grdRoom_RowCancelingEdit"
                                        OnRowEditing="grdRoom_RowEditing" OnRowUpdating="grdRoom_RowUpdating">
                                        <Columns>
                                            <asp:BoundField DataField="Name" HeaderText="Room Name">
                                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridViewItemStyle" Width="250px" />
                                            </asp:BoundField>
                                            <asp:CommandField ShowEditButton="True" HeaderText="Edit">
                                                <ItemStyle ForeColor="Maroon" CssClass="GridViewItemStyle" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                            </asp:CommandField>
                                            <asp:TemplateField Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRoom_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"RmID") %>'
                                                        Visible="False"></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <HeaderStyle CssClass="col_1" HorizontalAlign="Left" />
                                        <AlternatingRowStyle CssClass="col_2" />
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="grdRoom" EventName="RowCancelingEdit" />
                        <asp:AsyncPostBackTrigger ControlID="grdRoom" EventName="RowEditing" />
                        <asp:AsyncPostBackTrigger ControlID="grdRoom" EventName="RowUpdating" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlRack" runat="server" CssClass="pnlItemsFilter" Style="width: 720px">
            <div runat="server" class="Purchaseheader">
                Rack Master &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp <em><span style="font-size: 7.5pt">Press esc to close</span></em>
            </div>
            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                <ContentTemplate>
                    <table style="width: 720px; border-collapse: collapse">
                        <tr>
                            <td style="width: 200px"></td>
                            <td class="auto-style2" style="width: 300px" style="text-align: center">
                                <asp:RadioButtonList ID="rbtnAlmirah" runat="server" AutoPostBack="True" Enabled="true" OnSelectedIndexChanged="rbtnAlmirah_SelectedIndexChanged" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True" Value="0">Add New
                                    </asp:ListItem>
                                    <asp:ListItem Value="1">Edit</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td>
                                <%-- <asp:CheckBox ID="editprerack" runat="server" OnCheckedChanged="editprerack_CheckedChanged" Text="Edit Previous Data" />--%>
                            </td>
                            <td style="width: 200px"></td>
                        </tr>
                        <tr>
                            <td align="center" colspan="4">
                                <asp:Label ID="lblMSGAlmirah" runat="server" CssClass="ItDoseLblError"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 200px"></td>
                            <td style="text-align: right;" class="auto-style2">Room :&nbsp;
                            </td>
                            <td style="width: 270px; text-align: left;">
                                <asp:DropDownList ID="cmbRoomPopUp" CssClass="requiredField" runat="server" Width="194px" TabIndex="2" ToolTip="Select Room" AutoPostBack="true" OnSelectedIndexChanged="cmbRoomPopUp_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqRoom" SetFocusOnError="true" runat="server" ControlToValidate="cmbRoomPopUp"
                                    ValidationGroup="SaveRack" InitialValue="0" ErrorMessage="Select Room" Display="None"></asp:RequiredFieldValidator>
                            </td>
                            <td style="width: 200px">
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom"
                                    ValidChars="0123456789" TargetControlID="txtMaxNoRecord">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 200px"></td>
                            <td class="auto-style2" style="text-align: right;">Rack Name :&nbsp;
                            </td>
                            <td style="width: 270px; text-align: left;">
                                <asp:DropDownList ID="ddlrackname" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlrackname_SelectedIndexChanged" TabIndex="2" ToolTip="Select Rack" Width="200px">
                                </asp:DropDownList>
                                <asp:TextBox ID="txtAlmirah" CssClass="requiredField" runat="server" AutoCompleteType="Disabled" MaxLength="50" onkeyup="validatespaceRack();" ToolTip="Enter Rack Name" Width="195px"></asp:TextBox>
                                <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqAlmirah" runat="server" ControlToValidate="txtAlmirah" Display="None" ErrorMessage="Enter Rack Name" SetFocusOnError="true" ValidationGroup="SaveRack"></asp:RequiredFieldValidator>
                            </td>
                            <td style="width: 200px"></td>
                        </tr>
                        <tr>
                            <td style="width: 200px"></td>
                            <td class="auto-style2"></td>
                            <td style="width: 270px;"></td>
                            <td style="width: 200px"></td>
                        </tr>

                        <tr>
                            <td style="width: 200px"></td>
                            <td style="text-align: right;" class="auto-style2">No. Of Shelf  :&nbsp;
                            </td>
                            <td style="width: 270px; text-align: left;">
                                <asp:TextBox ID="txtNoOfShelf" runat="server" TabIndex="3" ToolTip="Enter No. of Shelf"
                                    Width="195px" CssClass="requiredField" MaxLength="5" AutoCompleteType="Disabled"></asp:TextBox>
                                <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqShelf" SetFocusOnError="true" runat="server" ControlToValidate="txtNoOfShelf"
                                    ValidationGroup="SaveRack" ErrorMessage="Enter No. Of Shelf" Display="None"></asp:RequiredFieldValidator>
                            </td>
                            <td style="width: 200px">
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom"
                                    ValidChars="0123456789" TargetControlID="txtNoOfShelf">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right;" colspan="2">Maximum No. of Files Per Shelf :&nbsp;
                            </td>
                            <td style="width: 270px; text-align: left;">
                                <asp:TextBox ID="txtMaxNoRecord" CssClass="requiredField" runat="server" AutoCompleteType="Disabled" MaxLength="5" TabIndex="4" ToolTip="Enter Maximum No. of Files Per Shelf" Width="195px"></asp:TextBox>
                                <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqFile" runat="server" ControlToValidate="txtMaxNoRecord" Display="None" ErrorMessage="Enter  Maximum No. of Files Per Shelf" SetFocusOnError="true" ValidationGroup="SaveRack"></asp:RequiredFieldValidator>
                            </td>
                            <td style="width: 200px"></td>
                        </tr>
                        <tr>
                            <td style="width: 200px"></td>
                            <td class="auto-style2"></td>
                            <td style="width: 270px; text-align: left;">
                                <asp:Button ID="btnAlmirah" OnClick="btnAlmirah_Click" runat="server" CssClass="ItDoseButton"
                                    Text="Save" OnClientClick="return validateRack();" ToolTip="Click to Save" TabIndex="5" ValidationGroup="SaveRack"></asp:Button>
                                <asp:Button ID="btnCancelRack" runat="server" Text="Close" TabIndex="6" ToolTip="Click to Close" CssClass="ItDoseButton" OnClick="btnCancelRack_Click" />
                            </td>
                            <td style="width: 200px">&nbsp;
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="rbtnAlmirah" EventName="SelectedIndexChanged" />

                    <asp:AsyncPostBackTrigger ControlID="ddlrackname" EventName="SelectedIndexChanged" />

                </Triggers>
            </asp:UpdatePanel>
            <br />
        </asp:Panel>
        
        <cc1:ModalPopupExtender ID="mpe1" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnMClose" PopupControlID="Panel1"
            TargetControlID="btn1" X="440" Y="50" BehaviorID="mpe1">
        </cc1:ModalPopupExtender>
        <cc1:ModalPopupExtender ID="mpopRack" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnCancelRack" PopupControlID="pnlRack"
            TargetControlID="btn2" X="340" Y="50" BehaviorID="mpopRack" OnCancelScript="ClearRack();">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
            <asp:Button ID="btnMClose" runat="server" CssClass="ItDoseButton" />
            <asp:Button ID="btn2" runat="server" CssClass="ItDoseButton" />

        </div>

        <div id="divCreateDocument" class="modal fade ">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 720px; height: 253px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divCreateDocument" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Create New Document</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22"></div>
                            <div class="row">
                            <div class="col-md-24">
                                <asp:Label ID="lblDocument" runat="server" CssClass="ItDoseLblError" />
                                 <asp:CheckBox ID="chkEdit" runat="server" Text="Is Edit" Font-Bold="True" OnCheckedChanged="chkEdit_CheckedChanged" AutoPostBack="true" />
                            </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Document Name</label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlDocument" runat="server" AutoPostBack="True"
                                            OnSelectedIndexChanged="ddlDocument_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtDocument" CssClass="requiredField" AutoCompleteType="Disabled" MaxLength="50" runat="server"
                                            onkeyup="validatespaceDoc();"></asp:TextBox>
                                    </div>
                                    
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Sequence No.</label>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtSequence" CssClass="requiredField" runat="server" Width="30px" MaxLength="5" onkeypress="return checkForSecondDecimal(this,event)"
                                            onkeyup="ValidateDots()" AutoCompleteType="Disabled"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="fEarn1" runat="server" TargetControlID="txtSequence"
                                            FilterType="Numbers">
                                        </cc1:FilteredTextBoxExtender>
                                        
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <asp:RadioButtonList ID="ddlActive" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                            <asp:ListItem Value="0">Deactive</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                         
                            </div>
                            <div class="col-md-1"></div>
                            </div>
                        </div>
                    <div class="modal-footer">
                        <div class="row">
                                    <div class="col-md-12" style="text-align:center">
                                        <asp:Button ID="btnSave2" OnClientClick="return validateDoc();" runat="server" Text="Save"
                                        OnClick="btnSave2_Click" ToolTip="Click to Save" CssClass="ItDoseButton" />
                                    </div>
                                    <div class="col-md-12" style="text-align:center">
                                         <asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="ItDoseButton"
                                        OnClick="btnCancel1_Click" ToolTip="Click to Close" />
                                        </div>
                                </div>
                        </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
