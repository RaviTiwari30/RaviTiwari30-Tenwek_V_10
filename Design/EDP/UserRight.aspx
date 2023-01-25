<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="UserRight.aspx.cs" Inherits="Design_EDP_UserRight" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        $(function () {
            $('#move-up').click(moveUp);
            $('#move-down').click(moveDown);
            $('#btnGenerate').click(UpdateSNo);
            $('#btnSaveMenu').click(UpdateSNo);
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
        }

        function UpdateSNo(e) {

            var list = new Array();
            var obj = new Object();
            var i = 1;
            $('#<%=lstAvailAbleRight.ClientID%> option').each(function () {
                obj.UrlID = $(this).val();
                obj.SNo = i;
                list.push(obj);
                i = i + 1;
                obj = new Object();

            });

            $.ajax({
                type: "POST",
                data: JSON.stringify({ RoleID: "'" + $('#ddlLoginType').val() + "'", RoleName: "" + $('#ddlLoginType option:selected').text() + "", fileRoleList: list }),
                url: "Services/EDP.asmx/UpdateMenuSNo",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {

                    if (result.d == "1") {
                        $("#lblMsg").text('Menu Generated Successfully');
                    }
                    else {
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
            return;
        }


    </script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sm" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <b>Privilege Management</b>
                <br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Privilege
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLoginType" ClientIDMode="Static" runat="server"  />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Menu
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMenu" ClientIDMode="Static" runat="server"  />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Avail.&nbsp;Menu
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:Label ID="lblMenu" runat="server" ClientIDMode="Static" CssClass="ItDoseLblSpBl" />
                            &nbsp;<input type="button" value="Change Menu Order" class="ItDoseButton" onclick="showMenu()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Privilege Detail
            </div>
            <table style="width: 100%">
                <tr>
                    <td></td>
                    <td>Available</td>
                    <td></td>
                    <td>Remaining
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <img id="move-up" src="../../Images/Up.png" alt="" />
                        <br />
                        <br />
                        <img id="move-down" src="../../Images/Down.png" alt="" /></td>
                    <td style="width:522px;">
                        <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="400px" SelectionMode="Multiple"
                            CssClass="ItDoseListbox" Width="485px"></asp:ListBox>
                    </td>
                    <td>
                        <br />
                        <img id="right" src="../../Images/Right.png" alt="" />
                        <br />
                        <br />
                        <br />
                        <br />
                        <img id="left" src="../../Images/Left.png" alt="" />
                        <td>
                            <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" Height="400px"
                                Width="480px" CssClass="ItDoseListbox"></asp:ListBox>
                        </td>
                        <td>&nbsp;</td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <input id="btnGenerate" type="button" class="ItDoseButton" value="Generate Menu" />

            </div>
        </div>
    </div>
    <asp:Panel ID="pnlMenu" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="320px">
        <div class="Purchaseheader" runat="server">
            Arrange Menu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeMenu()" />

                  to close</span></em>
        </div>
        <table style="width: 100%; text-align: center">
            <tr>
                <td colspan="2" style="text-align: center">
                    <div id="div_MenuName" style="overflow: auto; width: 300px">
                    </div>
                </td>
            </tr>
            <tr>

                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveMenuOrder();" value="Save" class="ItDoseButton" id="btnSaveMenu" title="Click To Save" />
                    &nbsp;
                                    <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpMenu" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlMenu"
        TargetControlID="btnNewMenu" OnCancelScript="closeMenu()" BehaviorID="mpMenu">
    </cc1:ModalPopupExtender>
    <asp:Button ID="btnNewMenu" Style="display: none" runat="server" />
    <script type="text/javascript">

        function showMenu() {
            $find('mpMenu').show();
            $.ajax({
                url: "Services/EDP.asmx/bindMenu",
                data: '{ RoleID: "' + $('#ddlLoginType').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    Data = jQuery.parseJSON(mydata.d);
                    if (Data.length > 0) {
                        $("#div_MenuName").empty();

                        var table = "<table id='tblResult' cellspacing='0' rules='all' border='1'><tr id='Header'> <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th> <th class='GridViewHeaderStyle' style='width:300px;'>MenuName</th><th class='GridViewHeaderStyle' style='width:30px;display:none'>MenuID</th></tr><tbody>";
                        for (var i = 0; i < Data.length; i++) {
                            var row = "<tr>";
                            row += "<td class='GridViewLabItemStyle' id='tdID' style='width:20px;cursor:pointer '>" + (i + 1) + "</td>";
                            row += "<td class='GridViewLabItemStyle'  id='tdMenuName' style='width:300px;cursor:pointer'>" + Data[i].MenuName + "</td>";
                            row += "<td class='GridViewLabItemStyle'  id='tdMenuID' style='width:30px;cursor:pointer;display:none'>" + Data[i].MenuID + "</td>";
                            row += "</tr>";
                            table += row;
                        }
                        table += "</tbody></table>";
                        $("#div_MenuName").append(table);

                        $("#tblResult").tableDnD({
                            onDragClass: "GridViewDragItemStyle",
                            onDragStart: function (table, row) {

                            }
                        });

                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }

        function closeMenu() {
            $find('mpMenu').hide();
        }
        function bindMenuSNo() {
            var dataMenu = new Array();
            var ObjMenu = new Object();
            var SNo = 1;
            $("#tblResult tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                $rowid = $(this).closest('tr');
                if (id != "Header") {
                    ObjMenu.SNo = SNo;
                    ObjMenu.MenuID = $.trim($rowid.find("#tdMenuID").text());
                    dataMenu.push(ObjMenu);
                    SNo = SNo + 1;
                    ObjMenu = new Object();
                }
                return dataMenu;
            });
        }
        function saveMenuOrder() {
            var dataMenu = new Array();
            var ObjMenu = new Object();
            var SNo = 1;
            $("#tblResult tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                $rowid = $(this).closest('tr');
                if ((id != "Header") && ($rowid.find("#tdMenuID").text() != "")) {
                    ObjMenu.SNo = SNo;
                    ObjMenu.MenuID = $.trim($rowid.find("#tdMenuID").text());
                    ObjMenu.RoleID = $('#ddlLoginType').val();
                    dataMenu.push(ObjMenu);
                    SNo = SNo + 1;
                    ObjMenu = new Object();
                }
            });
            $.ajax({
                url: "Services/EDP.asmx/UpdateMenu",
                data: JSON.stringify({ menu: dataMenu }),
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    bindLoadAvailMenu();
                    if (mydata.d == "1")
                        $("#lblMsg").text('Menu Order Saved Successfully And Generate Successfully');
                    else
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    $find('mpMenu').hide();
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpMenu')) {
                    $find('mpMenu').hide();
                }
            }

        }
    </script>
    <script type="text/javascript">
        function bindLoginType() {
            $("#ddlLoginType option").remove();
            $.ajax({
                url: "Services/EDP.asmx/bindLoginType",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    LoginType = jQuery.parseJSON(result.d);
                    for (i = 0; i < LoginType.length; i++) {
                        $("#ddlLoginType").append($("<option></option>").val(LoginType[i].ID).html(LoginType[i].RoleName));
                    }
                    $('#ddlLoginType').chosen();
                },
                error: function (xhr, status) {
                }
            });
        }
        function bindLoadMenu() {
            $("#ddlMenu option").remove();
            $.ajax({
                url: "Services/EDP.asmx/bindLoadMenu",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Menu = jQuery.parseJSON(result.d);
                    for (i = 0; i < Menu.length; i++) {
                        $("#ddlMenu").append($("<option></option>").val(Menu[i].ID).html(Menu[i].MenuName));
                    }
                    $("#ddlMenu").chosen();
                },
                error: function (xhr, status) {
                }
            });
        }
        function bindLoadAvailMenu() {

            $.ajax({
                url: "Services/EDP.asmx/LoadAvailMenu",
                data: '{RoleID:"' + $('#ddlLoginType').val() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    AvailMenu = result.d;
                    $("#lblMenu").text(AvailMenu);
                },
                error: function (xhr, status) {
                }
            });
        }
        $(function () {
            bindLoadMenu();
            bindLoginType();
            bindLoadAvailMenu();
            $("#ddlLoginType").live("change", function () {
                bindPage();
                bindAvailRight();
                bindLoadAvailMenu();
            });
            $("#ddlMenu").live("change", function () {
                bindPage();
                bindAvailRight();

            });
        });

        function bindPage() {
            var lstRight = $("#<%=lstRight.ClientID %>");
            $("#<%=lstRight.ClientID %> option").remove();
            $.ajax({
                url: "services/EDP.asmx/BindPage",
                data: '{LoginType:"' + $("#<%=ddlLoginType.ClientID %>").val() + '",MenuId:"' + $("#<%=ddlMenu.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    RightData = jQuery.parseJSON(result.d);
                    if (RightData != null) {
                        for (i = 0; i < RightData.length; i++) {
                            lstRight.append($("<option></option>").val(RightData[i].id).html(RightData[i].FileName));
                        }
                    }

                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindAvailRight() {
            var AvailAbleRight = $("#<%=lstAvailAbleRight.ClientID %>");
            $("#<%=lstAvailAbleRight.ClientID %> option").remove();
            $.ajax({
                url: "services/EDP.asmx/BindAvailRight",
                data: '{RoleID:"' + $("#<%=ddlLoginType.ClientID %>").val() + '",MenuId:"' + $("#<%=ddlMenu.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    pageData = jQuery.parseJSON(result.d);
                    if (pageData != null) {
                        for (i = 0; i < pageData.length; i++) {
                            AvailAbleRight.append($("<option></option>").val(pageData[i].Id).html(pageData[i].FileName));
                        }
                    }

                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        $(function () {
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
                        obj.URLId = $(this).val();
                        obj.RoleID = $('#<%=ddlLoginType.ClientID%>').val();
                        data.push(obj);
                    });
                    if (data.length > 0) {
                        $.ajax({
                            url: "services/EDP.asmx/RoleUpdate",
                            data: JSON.stringify({ Data: data }),
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: true,
                            dataType: "json",
                            success: function (result) {
                                if (result.d == "1") {
                                    $('#<%=lblMsg.ClientID%>').text('Record Update Successfully');
                                }

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
            $("#left").bind("click", function () {
                var cond = 0;
                if ($('#<%=lstRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Remaining');
                    return false;
                    cond = 1;
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
                        obj.URLId = $(this).val();
                        obj.RoleID = $('#<%=ddlLoginType.ClientID%>').val();
                        data.push(obj);

                    });

                    if (data.length > 0) {
                        $.ajax({
                            url: "services/EDP.asmx/RoleInsert",
                            data: JSON.stringify({ Data: data }),
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

        });
    </script>
</asp:Content>
