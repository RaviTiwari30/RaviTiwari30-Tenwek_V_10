<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DisplayNameMaster.aspx.cs" Inherits="Design_EDP_DisplayNameMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function myFunction(tbindex, inputvalue) {
            var input, filter, table, tr, td, i;
            filter = inputvalue.value.toUpperCase();
            table = document.getElementById("tb_DisplayName");
            tr = table.getElementsByTagName("tr");

            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[tbindex];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "\\" || keychar == "\"")
                return false;
            else
                return true;
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Display Name Master</b><br />
            <asp:Label ID="lblmsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Display Name Master       
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 16%; text-align: right" colspan="2">New&nbsp;Display&nbsp;Name&nbsp;:&nbsp;</td>
                    <td colspan="3">
                        <asp:TextBox ID="txtDisplayName" ClientIDMode="Static" runat="server" Width="300px" ToolTip="Enter Display Name" TabIndex="1" MaxLength="50" onkeypress="return check(this, event);"></asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <span id="spnDisplayNameID" style="display: none"></span>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%"></td>
                    <td style="width: 16%"></td>
                    <td style="width: 20%; text-align: center">
                        <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="saveDisplayName()" />
                        <input type="button" value="Update" style="display: none" class="ItDoseButton" id="btnUpdate" onclick="UpdateDisplayName()" />
                        &nbsp;<input type="button" value="Cancel" style="display: none" class="ItDoseButton" id="btnCancel" onclick="cancelDisplayName()" />
                    </td>
                    <td style="width: 25%"></td>
                    <td style="width: 25%"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">Display Name</div>
            <table>
                <tr>
                    <td style="width: 15%; text-align: right">Sarch By Name :&nbsp;</td>
                    <td style="width: 16%" colspan="2">
                        <input type="text" id="txtSearch" onkeyup="myFunction(2,this)" style="width: 300px" />
                    </td>
                    <td style="width: 20%; text-align: center">&nbsp;</td>
                    <td style="width: 25%">&nbsp;</td>
                    <td style="width: 25%">&nbsp;</td>
                </tr>
            </table>
            <div id="DisplayNameOutput" style="max-height: 375px; overflow-x: auto;"></div>
        </div>
    </div>
    <script id="tb_grdDisplayName" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_DisplayName" style="width:100%;border-collapse:collapse;">
		    <tr id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Display Name</th>                      
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Edit</th>
		    </tr>
            <#       
                var dataLength=DisplayNameData.length;
                for(var j=0;j<dataLength;j++)
                {            
                    var objRow = DisplayNameData[j];
            #>
            <tr id="<#=j+1#>">                            
                <td class="GridViewLabItemStyle"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none" ><#=objRow.ID#></td>                  
                <td class="GridViewLabItemStyle" id="tdName" style="width:200px;"><#=objRow.Name#></td>                                                                                                              
                <td class="GridViewLabItemStyle">
                    <img src="../../Images/edit.png" style="cursor:pointer" onclick="DisplayName(this)"  title="Click To Edit"/>
                </td>
            </tr>           
            <#}#>                     
        </table>   
    </script>

    <script type="text/javascript">
        function saveDisplayName() {
            $("#btnSave").attr('disabled', 'disabled');
            if ($.trim($("#txtDisplayName").val()) != "") {
                $("#lblmsg").text('');
                $.ajax({
                    url: "DisplayNameMaster.aspx/saveDisplayName",
                    data: '{DisplayName:"' + $.trim($("#txtDisplayName").val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            DisplayMsg('MM01', 'lblmsg');
                        }
                        else if (result.d == "2") {
                            $('#lblmsg').text('Display Name Already Exists');
                            $("#btnSave").removeAttr('disabled');
                            return;
                        }
                        else {
                            DisplayMsg('MM05', 'lblmsg');
                        }
                        hideDetail();
                        $("#btnSave").removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        DisplayMsg('MM05', 'lblmsg');
                    }
                });
            }
            else {
                $("#lblmsg").text('Please Enter Display Name');
                $("#txtDisplayName").focus();
                $("#btnSave").removeAttr('disabled');
            }
        }

        var DisplayNameData = "";

        function bindDisplayName() {
            $.ajax({
                url: "DisplayNameMaster.aspx/bindDisplayName",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        DisplayNameData = jQuery.parseJSON(result.d);
                        if (DisplayNameData != null) {
                            var output = $('#tb_grdDisplayName').parseTemplate(DisplayNameData);
                            $('#DisplayNameOutput').html(output);
                            $('#DisplayNameOutput').show();
                        }
                    }
                    else {
                        $('#DisplayNameOutput').html();
                        $('#DisplayNameOutput').hide();
                        DisplayMsg('MM04', 'lblmsg');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#DisplayNameOutput').html();
                    $('#DisplayNameOutput').hide();
                    DisplayMsg('MM05', 'lblmsg');
                }
            });
        }

        function hideDetail() {
            bindDisplayName();
            $("#btnSave").show();
            $("#btnUpdate,,#btnCancel").hide();
            $("#txtDisplayName").val('');
        }

        $(function () {
            bindDisplayName();
        });

        function DisplayName(rowid) {
            $("#lblmsg").text('');
            var ID = $(rowid).closest('tr').find("#tdID").text();
            $("#btnSave").hide();
            $("#btnUpdate,#btnCancel").show();
            $("#txtDisplayName").val($(rowid).closest('tr').find("#tdName").text());
            $("#spnDisplayNameID").text(ID);
            $("#txtDisplayName").focus();
            $('#txtDepartment').setCursorToTextEnd();
        }

        function UpdateDisplayName() {
            $("#btnUpdate").attr('disabled', 'disabled');
            if ($.trim($("#txtDisplayName").val()) != "") {
                $("#lblmsg").text('');
                $.ajax({
                    url: "DisplayNameMaster.aspx/UpdateDisplayName",
                    data: '{DisplayName:"' + $.trim($("#txtDisplayName").val()) + '",ID:"' + $("#spnDisplayNameID").text() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            DisplayMsg('MM02', 'lblmsg');
                        }
                        else if (result.d == "2") {
                            $('#lblmsg').text('Display Name Already Exists');
                            $("#btnUpdate").removeAttr('disabled');
                            return;
                        }
                        else {
                            DisplayMsg('MM05', 'lblmsg');
                        }
                        hideDetail();
                        $("#btnUpdate").removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;

                        DisplayMsg('MM05', 'lblmsg');
                    }
                });
            }
            else {
                $("#lblmsg").text('Please Enter Display Name');
                $("#btnUpdate").removeAttr('disabled');
            }
        }

        function cancelDisplayName() {
            $("#btnSave").show();
            $("#btnUpdate,#btnCancel").hide();
            $("#txtDisplayName").val('');
            $("#lblmsg").text('');
        }
    </script>
</asp:Content>

