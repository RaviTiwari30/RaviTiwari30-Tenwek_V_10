<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="FrameRight.aspx.cs" Inherits="Design_EDP_FrameRight" %>

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
                if (cond == 0) {
                    $('#<%=lblMsg.ClientID%>').text('');
                 
                    var options = $('#<%=lstRight.ClientID%> option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#<%=lstAvailAbleRight.ClientID%>').append(opt);
                    }
                    //   var options = $('#<% = lstAvailAbleRight.ClientID %> option');
                    //   $.each(options, function (index, item) {
                    //       values.push(item.innerHTML);
                    //   });
                    //   alert(values);
                    var data = new Array();
                    $('#<%=lstAvailAbleRight.ClientID%> option').each(function () {
                        var obj = new Object();
                        obj.URLId = $(this).val();
                        obj.RoleID = $('#<%=ddlLoginType.ClientID%>').val();
                        obj.SequenceNo = $(this).index();
                        data.push(obj);

                    });

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
                                $('#<%=lstAvailAbleRight.ClientID%> option').attr("selected", false);
                                ConButton();
                              
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
                        obj.URLId = $(this).val();
                        obj.RoleID = $('#<%=ddlLoginType.ClientID%>').val();
                        data.push(obj);
                    });


                    if (data.length > 0) {
                        $.ajax({
                            url: "services/Frame.asmx/FrameRoleUpdate",
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
                url: "services/Frame.asmx/BindFrame",
                data: '{FrameId:"' + $("#<%=ddlFrame.ClientID %>").val() + '",RoleID:"' + $("#<%=ddlLoginType.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    FrameData = jQuery.parseJSON(result.d);
                    if (FrameData != null) {
                        for (i = 0; i < FrameData.length; i++) {
                            FrameRight.append($("<option></option>").val(FrameData[i].id).html(FrameData[i].FrameName));
                        }
                    }
                    ConButton();
                    
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    
                }
            });
        }
        function LoginType() {
          
            var Login = $("#<%=lstAvailAbleRight.ClientID %>");
            $("#<%=lstAvailAbleRight.ClientID %> option").remove();
            $.ajax({
                url: "services/Frame.asmx/BindLoginType",
                data: '{FrameId:"' + $("#<%=ddlFrame.ClientID %>").val() + '",RoleID:"' + $("#<%=ddlLoginType.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    LoginData = jQuery.parseJSON(result.d);
                    if (LoginData != null) {
                        for (i = 0; i < LoginData.length; i++) {
                            Login.append($("<option></option>").val(LoginData[i].Id).html(LoginData[i].FrameName));
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
            LoginType();
            ConButton();

        }
        $(document).ready(function () {
            Frame();
            LoginType();
            ConButton();
        });

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
            $(document).ready(function () {
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
                obj.URLId = $(this).val();
                obj.RoleID = $("#<%=ddlLoginType.ClientID %>").val();
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
                obj.URLId = $(this).val();
                obj.RoleID = $("#<%=ddlLoginType.ClientID %>").val();
                data.push(obj);
            });
            SequenceUpdate(data);
            $('#<%=lstAvailAbleRight.ClientID%> :selected').focus().blur();
        }

        function SequenceUpdate(data) {
            $.ajax({
                url: "services/Frame.asmx/SequenceUpdate",
                data: JSON.stringify({ Data: data }),
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
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Privilege Frame Management</b>
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
                                Frame
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFrame" runat="server" onchange="Privilege()">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Privilege
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLoginType" onchange="Privilege()" runat="server" />
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
                    <td style="width:85px;">
                        <img id="move-up" src="../../Images/Up.png" alt="" />
                        <br />
                        <br />
                        <img id="move-down" src="../../Images/Down.png" alt="" />
                    </td>
                    <td style="width:520px;">
                        <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="450px" SelectionMode="Multiple"
                            CssClass="ItDoseListbox" Width="480px"></asp:ListBox>
                    </td>
                    <td>
                        <img id="left" src="../../Images/Left.png" alt="" />
                        <br />
                        <br />
                        <img id="right" src="../../Images/Right.png" alt="" />
                    </td>
                    <td>
                        <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" Height="450px"
                            Width="510px" CssClass="ItDoseListbox"></asp:ListBox>
                    </td>
                </tr>
            </table>

        </div>

    </div>
</asp:Content>
