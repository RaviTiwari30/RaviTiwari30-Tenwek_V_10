<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ShowTokenScreen.aspx.cs" Inherits="Design_Token_ShowTokenScreen" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function saveTokenSreen() {
            $('#btnSave').prop("disabled", true);
            var Dept = [];
            $("#<%=chkDocDepartment.ClientID%> input[type=checkbox]:checked").each(function () {
                Dept.push({ "DocDepartmentID": encodeURIComponent($(this).val()), "DocDepartmentName": encodeURIComponent($(this).next().html()), "ScreenNo": encodeURIComponent($("#<%=ddlScreenNo.ClientID%>").val()), "buttonType": encodeURIComponent($("#btnSave").val()) });
            });
            if (Dept != "") {
                $.ajax({
                    type: "POST",
                    url: "Services/token.asmx/saveTokenSreen",
                    data: JSON.stringify({ Dept: Dept }),
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
                            $("#<%=chkDocDepartment.ClientID%> input[type=checkbox]").prop('checked', false);
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
                $("#<%=lblmsg.ClientID%>").text('Please Select Department Name');
                $('#btnSave').prop("disabled", false);
            }
        }

        function SaveRadioToken() {
            $('#btnsaveRadio').prop("disabled", true);
            var Dept = [];
            $("#<%=chkRadioDepartment.ClientID%> input[type=checkbox]:checked").each(function () {
                Dept.push({ "DocDepartmentID": encodeURIComponent($(this).val()), "DocDepartmentName": encodeURIComponent($(this).next().html()), "ScreenNo": encodeURIComponent($("#<%=ddlScreenNo.ClientID%>").val()), "buttonType": encodeURIComponent($("#btnsaveRadio").val()) });
            });
            if (Dept != "") {
                $.ajax({
                    type: "POST",
                    url: "Services/token.asmx/SaveRadiologyToken",
                    data: JSON.stringify({ Dept: Dept }),
                    dataType: "json",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Content-type",
                                             "application/json; charset=utf-8");
                    },
                    async: true,
                    success: function (response) {
                        token = (response.d);
                        if (token != "0") {
                            bindRadiology();
                            $("#<%=chkRadioDepartment.ClientID%> input[type=checkbox]").prop('checked', false);
                            $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
                            $("#btncancel1").hide();
                            if ($("#btnsaveRadio").val() == "Save")
                                $("#<%=lblmsg.ClientID%>").text('Record Saved Successfully');
                            else
                                $("#<%=lblmsg.ClientID%>").text('Record Updated Successfully');
                            $("#btnsaveRadio").val('Save').prop("disabled", false);
                        }
                        else {
                            $("#<%=lblmsg.ClientID%>").text('Screen already merge to Department');
                            $('#btnsaveRadio').prop("disabled", false);
                            bindRadiology();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $("#<%=lblmsg.ClientID%>").text('Please Select Department Name');
                $('#btnSave').prop("disabled", false);
            }
        }

        function SaveLaboratoryToken() {
            $('#btnsaveLabvo').prop("disabled", true);
            var Dept = [];
            $("#<%=ChkLaboratorydepartment.ClientID%> input[type=checkbox]:checked").each(function () {
                Dept.push({ "DocDepartmentID": encodeURIComponent($(this).val()), "DocDepartmentName": encodeURIComponent($(this).next().html()), "ScreenNo": encodeURIComponent($("#<%=ddlScreenNo.ClientID%>").val()), "buttonType": encodeURIComponent($("#btnsaveLabvo").val()) });
            });
            if (Dept != "") {
                $.ajax({
                    type: "POST",
                    url: "Services/token.asmx/SaveLaboratoryToken",
                    data: JSON.stringify({ Dept: Dept }),
                    dataType: "json",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Content-type",
                                             "application/json; charset=utf-8");
                    },
                    async: true,
                    success: function (response) {
                        token = (response.d);
                        if (token != "0") {
                            bindLaboratory();
                            $("#<%=ChkLaboratorydepartment.ClientID%> input[type=checkbox]").prop('checked', false);
                            $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
                            $("#btncancel2").hide();
                            if ($("#btnsaveLabvo").val() == "Save")
                                $("#<%=lblmsg.ClientID%>").text('Record Saved Successfully');
                            else
                                $("#<%=lblmsg.ClientID%>").text('Record Updated Successfully');
                            $("#btnsaveLabvo").val('Save').prop("disabled", false);
                        }
                        else {
                            $("#<%=lblmsg.ClientID%>").text('Screen already merge to Department');
                            $('#btnsaveLabvo').prop("disabled", false);
                            bindLaboratory();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $("#<%=lblmsg.ClientID%>").text('Please Select Department Name');
                $('#btnSave').prop("disabled", false);
            }
        }
        $(document).ready(function () {
            bind();
            //bindRadiology();
            //bindLaboratory();
        });

        function bind() {
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/bindTokenSreen",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tb_SaveTokenScreen').parseTemplate(token);
                        $('#showTokenScreen').html(output);
                        $('#showTokenScreen').show();
                    }
                    else {
                        $('#showTokenScreen').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
        }

        function bindRadiology() {
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/BindRadioScreen",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tbRadilogy').parseTemplate(token);
                        $('#divRadioScreen').html(output);
                        $('#divRadioScreen').show();
                    }
                    else {
                        $('#divRadioScreen').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function bindLaboratory() {
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/BindLaboratoryScreen",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tb_laboratory').parseTemplate(token);
                        $('#divLabScreen').html(output);
                        $('#divLabScreen').show();
                    }
                    else {
                        $('#divLabScreen').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function show(rowid) {
            var docDepartmentID = $(rowid).closest('tr').find('#tdDocDepartmentID').text();
            window.open('../token/displaytoken.aspx?docDepartmentID=' + (docDepartmentID) + '');
        }

        function showRadiology(rowid) {
            var docDepartmentID = $(rowid).closest('tr').find('#tdDocDepartmentIDRadilogy').text();
            window.open('../token/DisplayRadiologyToken.aspx?docDepartmentID=' + (docDepartmentID) + '');
        }
        function showlaboratory(rowid) {
            var docDepartmentID = $(rowid).closest('tr').find('#tdDocDepartmentIDlaboratory').text();
            window.open('../token/DisplayLaboratoryToken.aspx?docDepartmentID=' + (docDepartmentID) + '');
        }
        function edit(rowid) {
            $(rowid).closest('tr').find('#btnEdit').prop("disabled", true);
            $("#<%=chkDocDepartment.ClientID%> input[type=checkbox]").prop('checked', false);
            var docDepartmentID = $(rowid).closest('tr').find('#tdDocDepartmentID').text();
            var sereenNo = $(rowid).closest('tr').find('#tdScreenNo').text();
            var len = docDepartmentID.split(',').length;
            var postData = new Array(len);
            postData = docDepartmentID.split(',');
            for (var i = 0; i < len; i++) {
                for (var k = 0; k <= $("#<%=chkDocDepartment.ClientID%> input[type=checkbox]").length ; k++) {
                    if (postData[i] == $("#<%=chkDocDepartment.ClientID%>").find('input:checkbox[value=' + postData[k] + ']').val()) {
                        $("#<%=chkDocDepartment.ClientID%>").find('input:checkbox[value=' + postData[i] + ']').prop('checked', true);
                    }
                }
            }
            $("#<%= ddlScreenNo.ClientID%>").val(sereenNo).attr("disabled", "true");
            $("#btnSave").val('Update');
            $("#btnCancel").show();
            $(rowid).closest('tr').find('#btnEdit').prop("disabled", false);
        }
        function editRadiology(rowid) {
            $(rowid).closest('tr').find('#btnradiologyedit').prop("disabled", true);
            $("#<%=chkRadioDepartment.ClientID%> input[type=checkbox]").prop('checked', false);
            var docDepartmentID = $(rowid).closest('tr').find('#tdDocDepartmentIDRadilogy').text();
            var sereenNo = $(rowid).closest('tr').find('#tdScreenNoRadilogy').text();
            var len = docDepartmentID.split(',').length;
            var postData = new Array(len);
            postData = docDepartmentID.split(',');
            for (var i = 0; i < len; i++) {
                for (var k = 0; k <= $("#<%=chkRadioDepartment.ClientID%> input[type=checkbox]").length ; k++) {
                     if (postData[i] == $("#<%=chkRadioDepartment.ClientID%>").find('input:checkbox[value=' + postData[k] + ']').val()) {
                         $("#<%=chkRadioDepartment.ClientID%>").find('input:checkbox[value=' + postData[i] + ']').prop('checked', true);
                    }
                }
            }
            $("#<%= ddlScreenNo.ClientID%>").val(sereenNo).attr("disabled", "true");
            $("#btnsaveRadio").val('Update');
            $("#btncancel1").show();
            $(rowid).closest('tr').find('#btnradiologyedit').prop("disabled", false);
        }
        function editlaboratory(rowid) {
            $(rowid).closest('tr').find('#btneditlaboratory').prop("disabled", true);
            $("#<%=ChkLaboratorydepartment.ClientID%> input[type=checkbox]").prop('checked', false);
            var docDepartmentID = $(rowid).closest('tr').find('#tdDocDepartmentIDlaboratory').text();
            var sereenNo = $(rowid).closest('tr').find('#tdScreenNolaboratory').text();
            var len = docDepartmentID.split(',').length;
            var postData = new Array(len);
            postData = docDepartmentID.split(',');
            for (var i = 0; i < len; i++) {
                for (var k = 0; k <= $("#<%=ChkLaboratorydepartment.ClientID%> input[type=checkbox]").length ; k++) {
                    if (postData[i] == $("#<%=ChkLaboratorydepartment.ClientID%>").find('input:checkbox[value=' + postData[k] + ']').val()) {
                        $("#<%=ChkLaboratorydepartment.ClientID%>").find('input:checkbox[value=' + postData[i] + ']').prop('checked', true);
                     }
                 }
             }
             $("#<%= ddlScreenNo.ClientID%>").val(sereenNo).attr("disabled", "true");
            $("#btnsaveLabvo").val('Update');
            $("#btncancel2").show();
            $(rowid).closest('tr').find('#btneditlaboratory').prop("disabled", false);
        }

        function cancelTokenSreen() {
            $("#<%=chkDocDepartment.ClientID%> input[type=checkbox]").prop('checked', false);
            $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
            $("#btnSave").val('Save');
            $("#btnCancel").hide();
        }
        function cancelRadioTokenSreen() {
            $("#<%=chkRadioDepartment.ClientID%> input[type=checkbox]").prop('checked', false);
            $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
            $("#btnsaveRadio").val('Save');
            $("#btncancel1").hide();
        }
        function cancelLaboTokenSreen() {
            $("#<%=ChkLaboratorydepartment.ClientID%> input[type=checkbox]").prop('checked', false);
            $("#<%= ddlScreenNo.ClientID%>").prop('selectedIndex', 0).prop("disabled", false);
            $("#btnsaveLabvo").val('Save');
            $("#btncancel2").hide();
        }

        function SelectAllIcu() {
            if ($('[id$=chkItem]').is(':checked')) {
                $('[id$=chkDocDepartment] input:checkbox').prop('checked', true);
                $('[id$=chkRadioDepartment] input:checkbox').prop('checked', true);
                $('[id$=ChkLaboratorydepartment] input:checkbox').prop('checked', true);
            }
            else {
                $('[id$=chkDocDepartment] input:checkbox').prop('checked', false);
                $('[id$=chkRadioDepartment] input:checkbox').prop('checked', false);
                $('[id$=ChkLaboratorydepartment] input:checkbox').prop('checked', false);
            }
        }

        function SelectDepartment() {
            if ($("#<%= ddldepartment.ClientID%>").val() == "1") {
                bind();
                $("#<%= chkDocDepartment.ClientID%>").css('display', 'block');
                $("#<%= chkRadioDepartment.ClientID%>").css('display', 'none');
                $("#<%= ChkLaboratorydepartment.ClientID%>").css('display', 'none');
                $('[id$=divOpdDisply]').css('display', 'block');
                $('[id$=divradiology]').css('display', 'none');
                $('[id$=divLaboratory]').css('display', 'none');
                $('[id$=showTokenScreen]').css('display', 'block');
                $('[id$=divRadioScreen]').css('display', 'none');
                $('[id$=divLabScreen]').css('display', 'none');
            }
            else if ($("#<%= ddldepartment.ClientID%>").val() == "2") {
                bindRadiology();
                $("#<%= chkDocDepartment.ClientID%>").css('display', 'none');
                $("#<%= chkRadioDepartment.ClientID%>").css('display', 'block');
                $("#<%= ChkLaboratorydepartment.ClientID%>").css('display', 'none');
                $('[id$=divOpdDisply]').css('display', 'none');
                $('[id$=divradiology]').css('display', 'block');
                $('[id$=divLaboratory]').css('display', 'none');
                $('[id$=showTokenScreen]').css('display', 'none');
                $('[id$=divRadioScreen]').css('display', 'block');
                $('[id$=divLabScreen]').css('display', 'none');
            }
            else {
                bindLaboratory();
                $("#<%= chkDocDepartment.ClientID%>").css('display', 'none');
                $("#<%= chkRadioDepartment.ClientID%>").css('display', 'none');
                $("#<%= ChkLaboratorydepartment.ClientID%>").css('display', 'block');
                $('[id$=divOpdDisply]').css('display', 'none');
                $('[id$=divradiology]').css('display', 'none');
                $('[id$=divLaboratory]').css('display', 'block');
                $('[id$=showTokenScreen]').css('display', 'none');
                $('[id$=divRadioScreen]').css('display', 'none');
                $('[id$=divLabScreen]').css('display', 'block');
            }
    }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="tsm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Show Token Screen</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                Department 
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Select Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldepartment" onchange="SelectDepartment();" runat="server">
                                <asp:ListItem Text="OPD" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Radiology" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Laboratory" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    </div>
                </div>
             <div class="row">
                 </div>
            <div class="Purchaseheader">
                Doctor Department 
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Screen No.
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
                        <div class="col-md-5">
                            <label class="pull-left">
                                Select All Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="checkbox" id="chkItem" onclick="SelectAllIcu();" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Department Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <asp:CheckBoxList ID="chkDocDepartment" runat="server" RepeatDirection="Horizontal" RepeatColumns="5"
                                RepeatLayout="Table">
                            </asp:CheckBoxList>
                             <asp:CheckBoxList ID="chkRadioDepartment" style="display:none" runat="server" RepeatDirection="Horizontal" RepeatColumns="5"
                                RepeatLayout="Table">
                            </asp:CheckBoxList>
                             <asp:CheckBoxList ID="ChkLaboratorydepartment" style="display:none" runat="server" RepeatDirection="Horizontal" RepeatColumns="5"
                                RepeatLayout="Table">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
            </div>

            <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr>
                    <td colspan="4">
                        <div id="showTokenScreen" style="max-height: 600px; overflow-x: auto;">
                        </div>
                        <div id="divRadioScreen" style="max-height: 600px; overflow-x: auto;display:none;">
                        </div>
                        <div id="divLabScreen" style="max-height: 600px; overflow-x: auto;display:none;">
                        </div>
                        <br />
                    </td>
                </tr>

            </table>
        </div>

        <div class="POuter_Box_Inventory" id="divOpdDisply" style="text-align: center;">
            <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveTokenSreen()" />&nbsp;&nbsp;
            <input type="button" style="display: none" id="btnCancel" value="Cancel" class="ItDoseButton" onclick="cancelTokenSreen()" />
        </div>
          <div class="POuter_Box_Inventory" id="divradiology" style="text-align: center;display:none">
            <input type="button" id="btnsaveRadio" value="Save" class="ItDoseButton" onclick="SaveRadioToken()" />&nbsp;&nbsp;
            <input type="button" style="display: none" id="btncancel1" value="Cancel" class="ItDoseButton" onclick="cancelRadioTokenSreen()" />
        </div>
         <div class="POuter_Box_Inventory" id="divLaboratory" style="text-align: center;display:none">
            <input type="button" id="btnsaveLabvo" value="Save" class="ItDoseButton" onclick="SaveLaboratoryToken()" />&nbsp;&nbsp;
            <input type="button" style="display: none" id="btncancel2" value="Cancel" class="ItDoseButton" onclick="cancelLaboTokenSreen()" />
        </div>

        <script id="tb_SaveTokenScreen" type="text/html">
            <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdTokenScreen"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Screen No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:420px;">Department Name</th>           
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
                    <td class="GridViewLabItemStyle" id="tdDocDepartmentName"  style="width:420px;text-align:center" ><#=objRow.DocDepartmentName#></td>                                      
                    <td class="GridViewLabItemStyle" id="tdDocDepartmentID" style="width:60px;display:none"><#=objRow.DocDepartmentID#></td>                                                                                         
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

           <script id="tbRadilogy" type="text/html">
            <table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table1"
     style="width:100%;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Screen No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:420px;">Department Name</th>           
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
                    <tr id="Tr2">                            
                    <td class="GridViewLabItemStyle" style="width:10px; text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdScreenNoRadilogy"  style="width:50px;text-align:center" ><#=objRow.ScreenNo#></td>
                    <td class="GridViewLabItemStyle" id="tdDocDepartmentNameRadilogy"  style="width:420px;text-align:center" ><#=objRow.DocDepartmentName#></td>                                      
                    <td class="GridViewLabItemStyle" id="tdDocDepartmentIDRadilogy" style="width:60px;display:none"><#=objRow.DocDepartmentID#></td>                                                                                         
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Edit"   id="btnradiologyedit"  class="ItDoseButton" onclick="editRadiology(this);"  />                                                                                                                             
                    </td>   
                         <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Show"   id="btnradiologyshow"  class="ItDoseButton" onclick="showRadiology(this);"  />                                                                                                        
                    </td>                    
                    </tr>            
        <#}        
        #>      
     </table> 
           </script>

         <script id="tb_laboratory" type="text/html">
            <table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table2"
    style="width:100%;border-collapse:collapse;">
		<tr id="Tr3">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Screen No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:420px;">Department Name</th>           
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
                    <tr id="Tr4">                            
                    <td class="GridViewLabItemStyle" style="width:10px; text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdScreenNolaboratory"  style="width:50px;text-align:center" ><#=objRow.ScreenNo#></td>
                    <td class="GridViewLabItemStyle" id="tdDocDepartmentNamelaboratory"  style="width:420px;text-align:center" ><#=objRow.DocDepartmentName#></td>                                      
                    <td class="GridViewLabItemStyle" id="tdDocDepartmentIDlaboratory" style="width:60px;display:none"><#=objRow.DocDepartmentID#></td>                                                                                         
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Edit"   id="btneditlaboratory"  class="ItDoseButton" onclick="editlaboratory(this);"  />                                                                                                                             
                    </td>   
                         <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Show"   id="btnshowlaboratory"  class="ItDoseButton" onclick="showlaboratory(this);"  />                                                                                                        
                    </td>                    
                    </tr>            
        <#}        
        #>      
     </table> 
        </script>
    </div>

</asp:Content>

