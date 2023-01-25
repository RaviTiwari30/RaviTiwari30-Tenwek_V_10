<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetWardScreen.aspx.cs" Inherits="Design_IPD_SetWardScreen" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            bind();
        })
        function SelectAllIcu() {
            if ($('[id$=chkItem]').is(':checked')) {
                $('[id$=chkDataitem] input:checkbox').prop('checked', true);
            }
            else {
                $('[id$=chkDataitem] input:checkbox').prop('checked', false);
            }
        }
        function SelectAllWard() {
            if ($('[id$=chkwrd]').is(':checked')) {
                $('[id$=chkward] input:checkbox').prop('checked', true);
            }
            else {
                $('[id$=chkward] input:checkbox').prop('checked', false);
            }
        }

        function saveTokenSreen() {
            $('#btnSave').prop("disabled", true);
            var Dept = [];
            var Detail = [];
            $("#<%=chkward.ClientID%> input[type=checkbox]:checked").each(function () {
                Dept.push({
                    "WardID": encodeURIComponent($(this).val()),
                    "WardName": encodeURIComponent($(this).next().html()),
                    "ScreenNo": encodeURIComponent($("#<%=ddlScreenNo.ClientID%>").val()),
                    "buttonType": encodeURIComponent($("#btnSave").val())
                });
            });
            $("#<%=chkDataitem.ClientID%> input[type=checkbox]:checked").each(function () {
                Detail.push({
                    "DataItemID": encodeURIComponent($(this).val()),
                    "DataItemName": encodeURIComponent($(this).next().html())
                });
            });
            if (Dept != "") {
                if (Detail != "") {
                    $.ajax({
                        type: "POST",
                        url: "SetWardScreen.aspx/saveWardSreen",
                        data: JSON.stringify({ Dept: Dept, Detail: Detail }),
                        dataType: "json",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("Content-type",
                                                 "application/json; charset=utf-8");
                        },
                        async: true,
                        success: function (response) {
                            token = (response.d);
                            if (token != "0") {
                                bind();
                                $("#<%=chkward.ClientID%> input[type=checkbox]").prop('checked', false);
                                $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
                                $("#btnCancel").hide();
                                if ($("#btnSave").val() == "Save")
                                    $("#<%=lblmsg.ClientID%>").text('Record Saved Successfully');
                                else
                                    $("#<%=lblmsg.ClientID%>").text('Record Updated Successfully');
                                $("#btnSave").val('Save').prop("disabled", false);
                            }
                            else {
                                $("#<%=lblmsg.ClientID%>").text('Screen already merge to Department');
                                $('#btnSave').prop("disabled", false);
                                bind();
                            }
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }
                else {
                    $("#<%=lblmsg.ClientID%>").text('Please Select Data Item  ');
                    $('#btnSave').prop("disabled", false);
                }
            }
            else {
                $("#<%=lblmsg.ClientID%>").text('Please Select Ward Name');
                $('#btnSave').prop("disabled", false);
            }
        }
        function bind() {
            $.ajax({
                type: "POST",
                url: "SetWardScreen.aspx/bindWardSreen",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tb_SaveTokenScreen').parseTemplate(token);
                        $('#DivWardScreen').html(output);
                        $('#DivWardScreen').show();
                    }
                    else {
                        $('#DivWardScreen').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
        }
        function edit(rowid) {
            $(rowid).closest('tr').find('#btnEdit').prop("disabled", true);
            $("#<%=chkDataitem.ClientID%> input[type=checkbox]").prop('checked', false);
            $("#<%=chkward.ClientID%> input[type=checkbox]").prop('checked', false);
            var WardId = $(rowid).closest('tr').find('#tdWardID').text();
            var DataID = $(rowid).closest('tr').find('#tdDataId').text();
            var sereenNo = $(rowid).closest('tr').find('#tdScreenNo').text();
            var len = DataID.split(',').length;
            var length = WardId.split(',').length;
            var postData = new Array(len);
            postData = DataID.split(',');
            for (var i = 0; i < len; i++) {
                for (var k = 0; k <= $("#<%=chkDataitem.ClientID%> input[type=checkbox]").length ; k++) {
                    if (postData[i] == $("#<%=chkDataitem.ClientID%>").find('input:checkbox[value=' + postData[k] + ']').val()) {
                        $("#<%=chkDataitem.ClientID%>").find('input:checkbox[value=' + postData[i] + ']').prop('checked', true);
                    }
                }
            }
            var WardData = new Array(length);
            WardData = WardId.split(',');
            for (var j = 0; j < length; j++) {
                for (var l = 0; l <= $("#<%=chkward.ClientID%> input[type=checkbox]").length ; l++) {
                    if (WardData[j] == $("#<%=chkward.ClientID%>").find('input:checkbox[value=' + WardData[l] + ']').val()) {
                        $("#<%=chkward.ClientID%>").find('input:checkbox[value=' + WardData[j] + ']').prop('checked', true);
                    }
                }
            }
            $("#<%= ddlScreenNo.ClientID%>").val(sereenNo).attr("disabled", "true");
            $("#btnSave").val('Update');
            $("#btnCancel").show();
            $(rowid).closest('tr').find('#btnEdit').prop("disabled", false);
        }
        function show(rowid) {
            var WardID = $(rowid).closest('tr').find('#tdWardID').text();
            window.open('../IPD/DisplayWardScreen.aspx?WardID=' + (WardID) + '');
        }
        function cancelSreen() {
            $("#<%=chkward.ClientID%> input[type=checkbox]").prop('checked', false);
            $("#<%=chkDataitem.ClientID%> input[type=checkbox]").prop('checked', false);
            $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
            $("#btnSave").val('Save');
            $("#btnCancel").hide();
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="tsm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set IPD Ward Screen</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
         <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Screen 
            </div>
               <div class="row">
                    <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                          <div class="col-md-3">
                            <label class="pull-left">
                                Select Screen
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                              <div class="col-md-3">
                            <asp:DropDownList ID="ddlScreenNo" runat="server" Width="60px">
                                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        </div>
                    </div>
                   
                   </div>
             </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Ward 
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Ward
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-15">
                            <asp:CheckBoxList ID="chkward" runat="server" RepeatDirection="Horizontal" RepeatColumns="5"
                                RepeatLayout="Table">
                            </asp:CheckBoxList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select All Ward
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <input type="checkbox" id="chkwrd" onclick="SelectAllWard();" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
            </div>
            <div class="Purchaseheader">
                Display Data item
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Data Item  Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-15">
                            <asp:CheckBoxList ID="chkDataitem" runat="server" RepeatDirection="Horizontal" RepeatColumns="7"
                                RepeatLayout="Table">
                            </asp:CheckBoxList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select All Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <input type="checkbox" id="chkItem" onclick="SelectAllIcu();" />
                        </div>
                    </div>
                </div>
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr>
                    <td colspan="4">
                        <div id="DivWardScreen" style="max-height: 600px; overflow-x: auto;">
                        </div>
                        <br />
                    </td>
                </tr>
            </table>
        </div>

        <div class="POuter_Box_Inventory" id="divOpdDisply" style="text-align: center;">
            <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveTokenSreen()" />&nbsp;&nbsp;
            <input type="button" style="display: none" id="btnCancel" value="Cancel" class="ItDoseButton" onclick="cancelSreen()" />
        </div>

         <script id="tb_SaveTokenScreen" type="text/html">
            <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdTokenScreen"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Screen No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:420px;">Ward Name</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:420px;">Data Item Name</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">WardID</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">DepartmentID</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Show</th>           
		</tr>
        <#       
        var dataLength=token.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = token[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px; text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdScreenNo"  style="width:50px;text-align:center" ><#=objRow.ScreenNo#></td>
                    <td class="GridViewLabItemStyle" id="tdWardname"  style="width:420px;text-align:center" ><#=objRow.WardName#></td> 
                    <td class="GridViewLabItemStyle" id="tdDataName"  style="width:420px;text-align:center" ><#=objRow.DataItemName#></td>                                      
                    <td class="GridViewLabItemStyle" id="tdWardID" style="width:60px;display:none"><#=objRow.WardID#></td>  
                    <td class="GridViewLabItemStyle" id="tdDataId" style="width:60px;display:none"><#=objRow.DataItemID#></td>                                                                                        
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Edit"   id="btnEdit"  class="ItDoseButton" onclick="edit(this);"  />                                                                                                                             
                    </td>   
                         <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Show"   id="btnShow"  class="ItDoseButton" onclick="show(this);"  />                                                                                                        
                    </td>                    
                    </tr>            
        <#}        
        #>      
     </table> 
        </script>
    </div>
</asp:Content>

