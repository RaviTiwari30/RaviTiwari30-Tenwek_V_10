<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CPOEMenuRight.aspx.cs" Inherits="Design_CPOE_CPOEMenuRight" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function showDirectory() {
            var val = window.showModalDialog("../Edp/browseDirectory.aspx?Frame=Frame", 'view', "dialogHeight: 480px; dialogWidth: 340px; edge: Raised; center: Yes; help: Yes; resizable: Yes; status: No;");
            if (val != undefined)
                document.getElementById('<%=txtURL.ClientID %>').value = val;
            return false;
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>CPOE Menu Right</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Role
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlRole" runat="server" ClientIDMode="Static" onchange="bindPrivilege()"></asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                <asp:Label ID="lblType" Text="Doctor" runat="server" ClientIDMode="Static"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlDoctor" runat="server" ClientIDMode="Static" onchange="bindPrivilege()">
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlDoctorDept" Style="display: none" ClientIDMode="Static" runat="server" onchange="bindPrivilege()">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList ID="rbtType" runat="server" ClientIDMode="Static" onchange="bindPrivilege()" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">CPOE Menu</asp:ListItem>
                                <asp:ListItem Value="2">Prescription Tab</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                        
                        <div class="col-md-3">
<input type="button" id="btnHeader" value="New Menu Header" class="ItDoseButton" onclick="showHeaderFrame()" />

                            </div>
                        <div class="col-md-3">

                                                    
                            <asp:Button ID="btnCreate" runat="server" CssClass="ItDoseButton" ClientIDMode="Static" Text="Create New Menu" />
                            <input type="button" id="btnDefaultSelect" value="Default Tab Selection" onclick="showDefaultTabModel()" />
                        </div>
                       
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                          <asp:RadioButtonList ID="rblType" onclick="checkDocType()" Style="display: none" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Doctor Wise" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Department Wise" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            Privilege Detail
        </div>
        <table style="width: 100%">
            <tr>
                <td style="width: 5%"></td>
                <td style="width: 40%">Available</td>
                <td style="width: 5%"></td>
                <td style="width: 40%">Remaining</td>
            </tr>
            <tr>
                <td style="width: 5%">
                    <img id="move-up" src="../../Images/Up.png" alt="" />
                    <br />
                    <br />
                    <img id="move-down" src="../../Images/Down.png" alt="" />
                </td>
                <td style="width: 40%">
                    <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="400px" SelectionMode="Multiple" CssClass="ItDoseListbox"></asp:ListBox>
                </td>
                <td style="width: 5%">
                    <img id="left" src="../../Images/Left.png" alt="" />
                    <br />
                    <br />
                    <img id="right" src="../../Images/Right.png" alt="" /></td>
                <td style="width: 40%">
                    <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" Height="400px" CssClass="ItDoseListbox"></asp:ListBox>
                </td>
                 <td style="width: 5%"></td>
            </tr>
        </table>
    </div>
    <cc1:ModalPopupExtender ID="mpCPOE" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlCPOE"
        TargetControlID="btnCreate" OnCancelScript="cancelCPOE()" BehaviorID="mpCPOE">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlCPOE" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="590px" Height="60%">
        <div id="Div2" class="Purchaseheader" runat="server">
            Create New CPOE Menu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="cancelCPOE()" />

                  to close</span></em>
        </div>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblMenuError" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right; width: 20%">Role :&nbsp;
                </td>
                <td>
                    <asp:DropDownList ID="ddlRoleMenu" runat="server" Width="244px" ClientIDMode="Static" onchange="bindPrivilege()"></asp:DropDownList>


                </td>
            </tr>
            <tr>
                <td style="text-align: right; width: 20%">Menu Name :&nbsp;
                </td>
                <td style="text-align: left; width: 80%">
                    <asp:TextBox ID="txtMenuName" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" MaxLength="50" Width="240px"></asp:TextBox>
                    <span style="color: red; font-size: 10px;">*</span>

                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;URL :&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtURL" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" MaxLength="50" Width="240px"></asp:TextBox>
                    <span style="color: red; font-size: 10px;">*</span> <a href="javascript:void(0);" onclick="showDirectory();">
                        <img src="../../Images/view.GIF" style="border: none;" alt="" /></a>
                    <asp:Label ID="lblFile" runat="server" CssClass="ItDoseLabelSp" Text="(URL&nbsp;: ../CPOE/FileName.aspx)" Font-Size="10px"></asp:Label>

                </td>
            </tr>
            <tr>
                <td style="text-align: right">Description :&nbsp;
                </td>
                <td style="width: 80%">
                    <asp:TextBox ID="txtDescription" ClientIDMode="Static" runat="server" Width="240px"
                        TextMode="MultiLine"></asp:TextBox>

                </td>
            </tr>
            <tr>
                <td style="text-align: right">MenuHeader :&nbsp;
                </td>
                <td style="width: 80%">
                    <asp:DropDownList ID="ddlMenuHeader" runat="server" Width="244px" ClientIDMode="Static" ></asp:DropDownList>

                </td>
            </tr>


            <tr>

                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveMenu();" value="Save" class="ItDoseButton" id="btnSaveMenu" title="Click To Save" />
                    &nbsp;
                                    <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
       
     <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
  <cc1:ModalPopupExtender ID="mpeCreateFrameHeader" runat="server" CancelControlID="btnRCancelHeader"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlMenuHeader" PopupDragHandleControlID="dragHandle" BehaviorID="mpeCreateFrameHeader" OnCancelScript="ClearHeaderPopup();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlMenuHeader" runat="server" CssClass="pnlFilter" Style="display: none; width: 320px; height: 94px">
        <div id="Div1" class="Purchaseheader" runat="server">
            New Frame &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press
            esc to close
        </div>

        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td align="center">
                    <asp:Label ID="lblHeaderNameError" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" Text=" " />
                </td>

            </tr>
            <tr>
                <td> Header Menu Name  :&nbsp;
            <asp:TextBox ID="txtHeaderName" runat="server" ClientIDMode="Static" Font-Bold="true" MaxLength="20"></asp:TextBox>
                    <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>

            </tr>
        </table>

        <div class="filterOpDiv">
            <input id="btnMenuHeader" type="button" class="ItDoseButton" value="Save" onclick="SaveFrameMasterMenuHeader()" />
            &nbsp;<asp:Button ID="btnRCancelHeader" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>
   
        
         <div id="dvDefaultTab" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 40%;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeDefaultTabModel();" aria-hidden="true">×</button>
                        <h4 class="modal-title">Default Tab For Print</h4>
                    </div>
                    <div style="max-height: 400px; overflow: auto;" id="listDefaultTabs" class="modal-body">
                            <ul id="ulDefaultTabSelection"></ul>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="saveDefaultTabSeletion();">Save</button>
                        <button type="button" onclick="closeDefaultTabModel();">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function saveMenu() {
            if ($("#<%=txtMenuName.ClientID %>").val().trim() == "") {
                $('#<%=lblMenuError.ClientID%>').text('Please Enter Menu Name');
                $("#<%=txtMenuName.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtURL.ClientID %>").val().trim() == "") {
                $('#<%=lblMenuError.ClientID%>').text('Please Enter URL');
                $("#<%=txtURL.ClientID %>").focus();
                return false;
            }
            
            $.ajax({
                url: "CPOEMenuRight.aspx/saveMenu",
                data: '{MenuName:"' + $("#<%=txtMenuName.ClientID %>").val().trim() + '",URL:"' + $("#<%=txtURL.ClientID %>").val().trim() + '",Description:"' + $("#<%=txtDescription.ClientID %>").val().trim() + '",RoleID:"' + $("#<%=ddlRoleMenu.ClientID %>").val().trim() + '",MenuHeader:"' + $("#<%=ddlMenuHeader.ClientID %>").val().trim() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $('#<%=lblMsg.ClientID%>').text('Record Saved Successfully');
                    }

                    else if (result.d == "2") {
                        $('#<%=lblMsg.ClientID%>').text('Menu Name Already Exists');
                    }

                    cancelCPOE();
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
    }

    </script>
    <script type="text/javascript">
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpCPOE')) {
                    clearRefDoc();
                }
            }
        }
        function cancelCPOE() {
            $find('mpCPOE').hide();
            $("#txtMenuName,#txtURL,#txtDescription").val('');
            $("#lblMenuError").text('');
        }
        function bindPrivilege() {

            if (Number($('#rbtType input:checked').val()) == 2) {
                $("#btnCreate").hide();
                $("#btnDefaultSelect").show();
            }
            else {
                $("#btnCreate").show();
                $("#btnDefaultSelect").hide();
            }

            bindRightFrame();
            bindAvaFrame();
            ConButton();


        }

        function showHeaderFrame() {
            $find('mpeCreateFrameHeader').show();
        }

        function SaveFrameMasterMenuHeader() {
            if ($.trim($("#txtHeaderName").val()) == "") {
                $("#lblHeaderNameError").text('Please Enter Menu Header  Name');
                $("#txtNFrame").focus();
                return false;
            }
            if ($.trim($("#txtHeaderName").val()) != "") {
                $.ajax({
                    url: "../EDP/Services/Frame.asmx/SaveFrameMasterMenuHeader",
                    data: '{ HName: "' + $.trim($("#txtHeaderName").val()) + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#lblMsg").text('Record Saved Successfully');
                            $("#txtNFrame").val('');
                            window.location.reload();
                        }
                        else if (result.d == "2") {
                            $("#lblMsg").text('Menu Header Already Exists');
                            $("#txtNFrame").val('');
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                        }
                        $find('mpeCreateFrameHeader').hide();
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Record Not Saved');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }


        var closeDefaultTabModel = function () {
            $('#dvDefaultTab').closeModel();
        }
        var showDefaultTabModel = function () {
            data = {
                doctorId: $("#<%=ddlDoctor.ClientID %>").val(),
                RoleID: $("#<%=ddlRole.ClientID %>").val()
            }
            serverCall('CPOEMenuRight.aspx/bindDoctorTabs', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var ulDefaultTabSelection = $('#ulDefaultTabSelection');
                    ulDefaultTabSelection.find('li').remove();
                    $.each(responseData, function (i) {
                        var aa = '<li  role="menuitem"><a>'
                            + '<label class="trimList"  title="' + this.AccordianName + '" >'
                            + '<input   id="' + $.trim(this.Id) + '" value="' + this.Id + '" class="ui-all" type="checkbox" ';


                        if (this.IsDefaultCheck == 1)
                            aa = aa + ' checked="checked" ';

                            aa = aa + ' >' + this.AccordianName + '</label> </li>';
                        ulDefaultTabSelection.append(aa);
                    });
                    $('#dvDefaultTab').showModel();
                }
                else {
                    modelAlert("Doctor should have rights alteast one prescription tab");
                }
            });

        }
        var saveDefaultTabSeletion = function () {
            debugger;
            var data = [];
            $('#ulDefaultTabSelection li').each(function () {
                if ($(this).find('input').is(":checked")) {
                    data.push({
                        tabId: $(this).find('input').attr('id'),
                        doctorId: $("#<%=ddlDoctor.ClientID %>").val(),
                        roleID: $("#<%=ddlRole.ClientID %>").val()
                    })
                }
            });

            serverCall('CPOEMenuRight.aspx/saveDefaultTabSeletionRights', { Data: data }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                    {
                        $('#dvDefaultTab').hideModel();
                    }

                });
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {

            $("#left").bind("click", function () {
                if (($("#ddlDoctor").val() == "0") && ($("#ddlDoctor").is(':visible'))) {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Doctor');
                    $("#ddlDoctor").focus();
                    cond = 1;
                    return;
                }
                if (($("#ddlDoctorDept").val() == "0") && ($("#ddlDoctorDept").is(':visible'))) {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Doctor Department');
                    $("#ddlDoctorDept").focus();
                    cond = 1;
                    return;
                }
                var cond = 0;
                if ($('#<%=lstRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Remaining');
                    cond = 1;
                    return false;

                }
                if (cond == 0) {
                    $('#<%=lblMsg.ClientID%>').text('');
                   
                    var options = $('#<%=lstRight.ClientID%> option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#<%=lstAvailAbleRight.ClientID%>').append(opt);
                    }

                    var data = new Array();
                    $('#<%=lstAvailAbleRight.ClientID%> option').each(function () {
                        var obj = new Object();
                        obj.MenuID = $(this).val();
                        obj.RoleID = $('#<%=ddlRole.ClientID%>').val();
                        obj.SequenceNo = $(this).index();
                        if ($("#ddlDoctor").is(':visible')) {
                            obj.doctorID = $('#<%=ddlDoctor.ClientID%>').val();
                            obj.Type = "1";
                        }
                        else {
                            obj.doctorDeptID = $('#<%=ddlDoctorDept.ClientID%>').val();
                            obj.Type = "2";
                        }
                        data.push(obj);

                    });

                    if (data.length > 0) {
                        $.ajax({
                            url: "CPOEMenuRight.aspx/menuInsert",
                            data: JSON.stringify({ Data: data, type: Number($('#rbtType input:checked').val()) }),
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: true,
                            dataType: "json",
                            success: function (result) {
                                if (result.d == "1") {
                                    $('#<%=lblMsg.ClientID%>').text('Record Saved Successfully');
                                }
                                $('#<%=lstAvailAbleRight.ClientID%> option').attr("selected", false);
                                bindPrivilege();
                             
                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                             
                            }
                        });
                    }

                }
                else {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Remaining');
                    return false;
                }
            });

            $("#right").bind("click", function () {
                $('#<%=lstRight.ClientID%> option').prop("selected", false);
                var cond = 0;
                if ($('#<%=lstAvailAbleRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Available');
                    return false;
                    cond = 1;
                }
                if (cond == 0) {
                   
                    var options = $('#<%=lstAvailAbleRight.ClientID%> option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#<%=lstRight.ClientID%>').append(opt);
                    }

                    var data = new Array();
                    $('#<%=lstRight.ClientID%> option').each(function () {
                        var obj = new Object();
                        obj.MenuID = $(this).val();
                        obj.RoleID = $('#<%=ddlRole.ClientID%>').val();
                       if ($("#ddlDoctor").is(':visible')) {
                           obj.doctorID = $('#<%=ddlDoctor.ClientID%>').val();
                            obj.Type = "1";
                        }
                        else {
                            obj.doctorDeptID = $('#<%=ddlDoctorDept.ClientID%>').val();
                            obj.Type = "2";
                        }

                       data.push(obj);
                   });
                    if (data.length > 0) {
                        $.ajax({
                            url: "CPOEMenuRight.aspx/menuUpdate",
                            data: JSON.stringify({ Data: data, type: Number($('#rbtType input:checked').val()) }),
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: true,
                            dataType: "json",
                            success: function (result) {
                                if (result.d == "1") {
                                    $('#<%=lblMsg.ClientID%>').text('Record Update Successfully');
                                }
                                bindPrivilege();
                             
                                $('#<%=lstRight.ClientID%> option').attr("selected", false);
                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                             
                            }
                        });
                    }
                }
                else {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Available');
                    return false;
                }
            });
         
        });
    </script>
    <script type="text/javascript">
        function bindRightFrame() {

            var FrameRight = $("#<%=lstRight.ClientID %>");
            $("#<%=lstRight.ClientID %> option").remove();
            $.ajax({
                url: "CPOEMenuRight.aspx/bindRightFrame",
                data: '{RoleID:"' + $("#<%=ddlRole.ClientID %>").val() + '",doctorID:"' + $("#<%=ddlDoctor.ClientID %>").val() + '",doctorDeptID:"' + $("#<%=ddlDoctorDept.ClientID %>").val() + '",type:"' + Number($('#rbtType input:checked').val()) + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    FrameData = jQuery.parseJSON(result.d);
                    if (FrameData != null) {
                        for (i = 0; i < FrameData.length; i++) {
                            FrameRight.append($("<option></option>").val(FrameData[i].Id).html(FrameData[i].MenuName));
                        }
                    }
                    ConButton();

                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
        }
        function bindAvaFrame() {
           
            var ava = $("#<%=lstAvailAbleRight.ClientID %>");
            $("#<%=lstAvailAbleRight.ClientID %> option").remove();
            $.ajax({
                url: "CPOEMenuRight.aspx/bindAvaType",
                data: '{doctorId:"' + $("#<%=ddlDoctor.ClientID %>").val() + '",RoleID:"' + $("#<%=ddlRole.ClientID %>").val() + '",doctorDeptID:"' + $("#<%=ddlDoctorDept.ClientID %>").val() + '",type:"' + Number($('#rbtType input:checked').val()) + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    AvaType = jQuery.parseJSON(result.d);
                    if (AvaType != null) {
                        for (i = 0; i < AvaType.length; i++) {
                            ava.append($("<option></option>").val(AvaType[i].Id).html(AvaType[i].MenuName));
                        }
                    }
                    ConButton();
                 
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                 
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {
            bindPrivilege();
            $('#move-up').click(moveUp);
            $('#move-down').click(moveDown);
        });
        function moveUp() {
            if ($('#<%=lstAvailAbleRight.ClientID%> option:selected').val() == null) {
                $('#<%=lblMsg.ClientID%>').text('Please Select To Move Up');
                return false;
            }
            $('#<%=lblMsg.ClientID%>').text('');
            $('#<%=lstAvailAbleRight.ClientID%> :selected').each(function (i, selected) {
                $(this).insertBefore($(this).prev());
            });
            var data = new Array();
            $('#<%=lstAvailAbleRight.ClientID%> option').each(function () {
                var obj = new Object();
                obj.SequenceNo = $(this).index();
                obj.MenuID = $(this).val();
                obj.RoleID = $("#<%=ddlRole.ClientID %>").val();
                if ($("#ddlDoctor").is(':visible')) {
                    obj.doctorID = $('#<%=ddlDoctor.ClientID%>').val();
                    obj.Type = "1";
                }
                else {
                    obj.doctorDeptID = $('#<%=ddlDoctorDept.ClientID%>').val();
                    obj.Type = "2";
                }
                data.push(obj);
            });
            SequenceUpdate(data);
            $('#<%=lstAvailAbleRight.ClientID%> :selected').focus().blur();
        }
        function moveDown() {
            if ($('#<%=lstAvailAbleRight.ClientID%> option:selected').val() == null) {
                $('#<%=lblMsg.ClientID%>').text('Please Select To Move Down');
                return false;
            }
            $('#<%=lblMsg.ClientID%>').text('');
            $('#<%=lstAvailAbleRight.ClientID%> :selected').each(function (i, selected) {
                $(this).insertAfter($(this).next());
            });
            var data = new Array();
            $('#<%=lstAvailAbleRight.ClientID%> option').each(function () {
                var obj = new Object();
                obj.SequenceNo = $(this).index();
                obj.MenuID = $(this).val();
                obj.RoleID = $("#<%=ddlRole.ClientID %>").val();
                if ($("#ddlDoctor").is(':visible')) {
                    obj.doctorID = $('#<%=ddlDoctor.ClientID%>').val();
                    obj.Type = "1";
                }
                else {
                    obj.doctorDeptID = $('#<%=ddlDoctorDept.ClientID%>').val();
                    obj.Type = "2";
                }
                data.push(obj);
            });
            SequenceUpdate(data);
            $('#<%=lstAvailAbleRight.ClientID%> :selected').focus().blur();
        }
        function SequenceUpdate(data) {
            $.ajax({
                url: "CPOEMenuRight.aspx/SequenceUpdate",
                data: JSON.stringify({ Data: data, type: Number($('#rbtType input:checked').val()) }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    SequenceData = jQuery.parseJSON(result.d);
                    if (result.d == "1") {
                        $('#<%=lblMsg.ClientID%>').text('');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function ConButton() {
            if ($('#<%=lstAvailAbleRight.ClientID%> option').length > 0) {
                 $("#right").show();
                 $('#move-up').show();
                 $('#move-down').show();
             }
             else {
                 $("#right").hide();
                 $('#move-up').hide();
                 $('#move-down').hide();
             }
             if ($('#<%=lstRight.ClientID%> option').length > 0) {
                 $("#left").show();
             }
             else {
                 $("#left").hide();
             }
         }
    </script>
    <script type="text/javascript">
        $(function () {
            checkDocType();
        });
        function checkDocType() {

            if ($("#rblType input[type:radio]:checked").val() == "1") {
                $("#ddlDoctor").show();
                $("#ddlDoctorDept").hide();
                $("#lblType").text('Doctor ');
            }

            else {
                $("#ddlDoctor").hide();
                $("#ddlDoctorDept").show();
                $("#lblType").text('Department ');
            }
            // $("#ddlDoctor,#ddlDoctorDept").prop('selectedIndex', 0);
            bindPrivilege();
        }
    </script>
</asp:Content>

