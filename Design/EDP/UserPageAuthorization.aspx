<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UserPageAuthorization.aspx.cs" Inherits="Design_EDP_UserPageAuthorization" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        function RoleInsert() {
            var data = new Array();
            $('#<%=lstAvailAbleRight.ClientID%> option:selected').each(function () {
                var obj = new Object();
                obj.ID = $(this).val();
                obj.Name = $('#<%=lstAvailAbleRight.ClientID%> option:selected').text();
                data.push(obj);
            })
            if (data.length > 0) {
                $.ajax({
                    url: "services/Frame.asmx/FrameRoleInsert",
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
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;

                    }
                });
            }
        }
    </script>
    <script type="text/javascript">
        $(function () {

            $("#left").bind("click", function () {
                var cond = 0;
                if ($('#<%=lstRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Remaining');
                    // $('#<%=lstRight.ClientID%> option').prop("selected", true);
                    return false;
                    cond = 1;
                }
                // alert($('#<%=lstRight.ClientID%> option:selected').val());
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
                        // obj.MasterId = $(this).val();
                        obj.MasterId = $(this).val();
                        obj.Employee_ID = $('#<%=ddlUser.ClientID%>').val();
                        obj.RoleID = $('#<%=ddlLoginType.ClientID%>').val();
                        data.push(obj);
                    });

                    if (data.length > 0) {
                        $.ajax({
                            url: "Services/EDP.asmx/InsertRegisterPage",
                            data: JSON.stringify({ Data: data }),
                            type: "POST", // data has to be Posted    	        
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            async: false,
                            success: function (result) {
                                if (result.d == "1") {
                                    $('#<%=lblMsg.ClientID%>').text('Record Saved Successfully');
                                }
                                $('#<%=lstAvailAbleRight.ClientID%> option').attr("selected", false);
                                ConButton();

                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                                $('#<%=lblMsg.ClientID%>').text('error');

                            }
                        });
                    }

                }
                else {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Alleast One');
                    return false;
                }
            });

            $("#right").bind("click", function () {
                $('#<%=lstRight.ClientID%> option').prop("selected", false);
                var cond = 0;
                if ($('#<%=lstAvailAbleRight.ClientID%> option:selected').text() == "") {
                    $('#<%=lblMsg.ClientID%>').text('Please Select Available');
                    // $('#<%=lstAvailAbleRight.ClientID%> option').prop("selected", true);
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
                        obj.MasterId = $(this).val();
                        obj.Employee_ID = $('#<%=ddlUser.ClientID%>').val();
                        obj.RoleID = $('#<%=ddlLoginType.ClientID%>').val();
                        data.push(obj);
                    });


                    if (data.length > 0) {
                        $.ajax({
                            url: "services/EDP.asmx/NewRightUpdate",
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
                                ConButton();

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

        function Frame() {

            var FrameRight = $("#<%=lstRight.ClientID %>");
            $("#<%=lstRight.ClientID %> option").remove();
            $.ajax({
                url: "services/EDP.asmx/BindNonRegisterPage",
                data: '{Employee_ID:"' + $("#<%=ddlUser.ClientID %>").val() + '",RoleID:"' + $("#<%=ddlLoginType.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data != null) {
                        for (i = 0; i < Data.length; i++) {
                            FrameRight.append($("<option></option>").val(Data[i].ID).html(Data[i].PageName));
                        }
                    }
                    ConButton();

                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
            var FrameLeft = $("#<%=lstAvailAbleRight.ClientID %>");
            $("#<%=lstAvailAbleRight.ClientID %> option").remove();
            $.ajax({
                url: "services/EDP.asmx/BindRegisterPage",
                data: '{Employee_ID:"' + $("#<%=ddlUser.ClientID %>").val() + '",RoleID:"' + $("#<%=ddlLoginType.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data != null) {
                        for (i = 0; i < Data.length; i++) {
                            FrameLeft.append($("<option></option>").val(Data[i].MasterID).html(Data[i].PageName));
                        }
                    }
                    ConButton();

                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
        }


        function Privilege() {
            Frame();
            // LoginType();
            // ConButton();

        }
        $(document).ready(function () {
            $('#<%=ddlLoginType.ClientID%>,#<%=ddlUser.ClientID%>').chosen();
            Frame();
            // LoginType();
            ConButton();
        });

            function ConButton() {
                if ($('#<%=lstAvailAbleRight.ClientID%> option').length > 0) {
                $("#right").show();

            }
            else {
                $("#right").hide();

            }
            if ($('#<%=lstRight.ClientID%> option').length > 0) {
                $("#left").show();
            }
            else {
                $("#left").hide();
            }
        }
        $(document).ready(function () {

        });



    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>User Authorization Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Role
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLoginType" runat="server" ClientIDMode="Static" onchange="Privilege()">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                User
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUser" onchange="Privilege()" ClientIDMode="Static" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
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
            <table width="100%">
                <tr>
                    <td></td>
                    <td>Available
                    </td>
                    <td></td>
                    <td>Remaining
                    </td>
                </tr>
                <tr>
                    <td style="width: 84px;">&nbsp;<br />
                        <br />
                        &nbsp;</td>
                    <td style="width: 543px;">
                        <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="400px" ClientIDMode="Static"  SelectionMode="Multiple" CssClass="ItDoseListbox" Width="520px"></asp:ListBox>
                    </td>
                    <td>
                        <img id="left" src="../../Images/Left.png" alt="" />
                        <br />
                        <br />
                        <img id="right" src="../../Images/Right.png" alt="" />
                    </td>
                    <td>
                        <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" ClientIDMode="Static" Height="400px" Width="500px" CssClass="ItDoseListbox"></asp:ListBox>
                    </td>
                </tr>
            </table>

        </div>

        <div style="text-align: center" class="POuter_Box_Inventory">
            <input type="button" style="margin-top: 4px;" onclick="setRoleDefaultPage()" value="Set User Role Default Page" />
        </div>
    </div>



    <script type="text/javascript">
        var setRoleDefaultPage = function () {
            var selectedOptions = $('#lstAvailAbleRight option:selected');
            if (selectedOptions.length == 0) {
                modelAlert('Please Select File');
                return false;
            }
            if (selectedOptions.length > 1) {
                modelAlert('Please Select Single File');
                return false;
            }

            var data = {
                id: Number(selectedOptions.val()),
                roleID: Number($('#ddlLoginType').val()),
                empID: $('#ddlUser').val()
            }
            serverCall('Services/EDP.asmx/SetRoleDefaultPage', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response);
            });
        }
    </script>
</asp:Content>
