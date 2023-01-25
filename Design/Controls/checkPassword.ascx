<%@ Control Language="C#" AutoEventWireup="true" CodeFile="checkPassword.ascx.cs" Inherits="Design_Controls_checkPassword" %>

<style>
    #checkPasswordPanel {
        z-index: 999999999999;
        position:fixed;
        width:100%;
        height:100%;
        top:0;
        left:0;
        right:0;
        bottom:0;
        margin:0;
        padding:0;
        display: none;
        background-color:rgba(255, 252, 252, 0.50);
    }
    .checkPasswordPanel {
        position: fixed;
        top: 40%;
        left: 40%;
        background-color:#EAF3FD;
        -webkit-animation-name: animate; /* Safari 4.0 - 8.0 */
        -webkit-animation-duration: 0.8s; /* Safari 4.0 - 8.0 */
        animation-name: animate;
        animation-duration: 0.8s;

    }
    /* Safari 4.0 - 8.0 */
    @-webkit-keyframes animate {
        0% {
            left: 40%;
            top: 0;
        }

        100% {
            left: 40%;
            top: 40%;
        }
    }

    /* Standard syntax */
    @keyframes animate {
        0% {
            left: 40%;
            top: 0;
        }

        100% {
            left: 40%;
            top: 40%;
        }
    }
</style>
<script type="text/javascript">
    function validatePassword() {
        var password = '<%= Request.RequestContext.HttpContext.Session["Password"] %>';
        if (password.trim() == $('#txtPassword').val()) {
            $('#txtPassword').val('');
            $("#checkPasswordPanel").hide();
            return true;
        }
        else {
            $('#spnMsg').text('Invalid Password');
            $('#txtPassword').focus();
            return false;
        }
    }
    function checkForEnterKey(sender, e) {
        e = (e) ? e : (window.event) ? event : null;
        if (e) {
            var charCode = (e.charCode) ? e.charCode :
                        ((e.keyCode) ? e.keyCode :
                        ((e.which) ? e.which : 0));
            if ((charCode == 13)) {
                $("#btnCheck").click();
            }
        }
        return true;
    }

</script>
<div id="checkPasswordPanel">
        <div id="Pbody_box_inventory" style="width: 200px;" class="checkPasswordPanel">
            <div class="Purchaseheader" align="right" >
                
            
            <em><span style="font-size: 7.5pt">Press
            esc or click
                <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="$('#checkPasswordPanel').hide();" />
                to close</span></em>
            </div>
            <div>
                <table>
                    <tr>
                        <td style="text-align: center; color: red; font-size: 14px;" colspan="2">
                            <span id="spnMsg"></span>

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%; text-align: center">Enter Your Password :&nbsp;</td>
                         </tr>
                    <tr>
                        <td style="width: 30%; text-align: center">
                            <input type="password" id="txtPassword" onkeyup="return checkForEnterKey(this,event);"/></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <%--K<asp:Button ID="btnCheck" CssClass="ItDoseButton" runat="server" Text="OK" ClientIDMode="Static" />--%>
                            <input type="button" value="OK" id="btnCheck" class="ItDoseButton" />
                        </td>
                    </tr>
                </table>



            </div>

   </div>

</div>
