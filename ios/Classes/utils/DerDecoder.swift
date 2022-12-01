import ASN1Decoder

class DerDecoder {
    func decodePublicKey(_ data: Data,  _ error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecKey? {
        guard
            let asn1 = try? ASN1DERDecoder.decode(data: data),
            let keyData = asn1.first?.sub(1)?.value as? Data
        else {
            return nil
        }
        return SecKeyCreateWithData(
            keyData as CFData,
            [
                kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            ] as CFDictionary,
            error
        )
    }
}
